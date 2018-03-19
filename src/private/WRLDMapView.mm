#import "WRLDMapView.h"
#import "WRLDMapView+IBAdditions.h"

#import "WRLDApi.h"
#import "WRLDCoordinateWithAltitude.h"
#import "WRLDTouchTapInfo.h"
#import "WRLDTouchTapInfo+Private.h"
#import "WRLDGestureDelegate.h"
#import "WRLDIndoorMap+Private.h"
#import "WRLDNativeMapView.h"
#import "WRLDBlueSphere+Private.h"
#import "WRLDOverlayImpl.h"
#import "WRLDPoiService.h"
#import "WRLDPoiService+Private.h"
#import "WRLDPoiSearchResponse.h"
#import "WRLDPoiSearchResult.h"
#import "WRLDMapsceneService+Private.h"
#import "WRLDMapsceneRequestResponse+Private.h"
#import "WRLDMapsceneServiceHelpers.h"
#import "WRLDMapsceneStartLocation.h"
#import "WRLDRoutingService.h"
#import "WRLDRoutingService+Private.h"
#import "WRLDRoutingQueryResponse.h"
#import "RoutingQueryResponse.h"
#import "WRLDRoutingServiceHelpers.h"
#import "WRLDBuildingHighlight+Private.h"
#import "WRLDPickResult.h"
#import "WRLDPickingApiHelpers.h"
#import "WRLDMathApiHelpers.h"
#import "WRLDStringApiHelpers.h"
#import "WRLDIndoorEntityApiHelpers.h"

#include "EegeoApiHostPlatformConfigOptions.h"
#include "iOSApiRunner.h"
#include "iOSGlDisplayService.h"


#include "iOSApiHostModule.h"
#include "EegeoCameraApi.h"
#include "EegeoExpandFloorsApi.h"
#include "EegeoIndoorsApi.h"
#include "InteriorInteractionModel.h"
#include "EegeoApiHost.h"
#include "EegeoIndoorMapData.h"
#include "EegeoSpacesApi.h"
#include "EegeoRenderingApi.h"
#include "PoiSearchResults.h"
#include "MapCameraUpdateBuilder.h"
#include "MapCameraPositionBuilder.h"
#include "MapCameraAnimationOptionsBuilder.h"
#include "WRLDMapView+Private.h"
#include "EegeoMapsceneApi.h"
#include "MapsceneRequestResponse.h"
#include "EegeoBuildingsApi.h"
#include "EegeoPickingApi.h"
#include "EegeoIndoorEntityApi.h"

#include <string>

#import <QuartzCore/QuartzCore.h>

NSString * const WRLDMapViewDidEnterIndoorMapNotification = @"WRLDMapViewDidEnterIndoorMapNotification";
NSString * const WRLDMapViewDidExitIndoorMapNotification = @"WRLDMapViewDidExitIndoorMapNotification";
NSString * const WRLDMapViewDidChangeFloorNotification = @"WRLDMapViewDidChangeFloorNotification";

NSString * const WRLDMapViewNotificationPreviousFloorIndex = @"WRLDMapViewNotificationPreviousFloorIndex";
NSString * const WRLDMapViewNotificationCurrentFloorIndex = @"WRLDMapViewNotificationCurrentFloorIndex";

@interface WRLDMapView () <GLKViewDelegate>

@property (nonatomic) GLKView *glkView;
@property (nonatomic) EAGLContext *glContext;
@property (nonatomic) WRLDGestureDelegate* apiGestureDelegate;
@property (nonatomic) WRLDNativeMapView* nativeMapView;

@property (nonatomic) CADisplayLink* displayLink;

@property (nonatomic) CFTimeInterval prevDisplayLinkTimestamp;

@end


@implementation WRLDMapView
{
    Eegeo::ApiHost::iOS::iOSApiRunner* m_pApiRunner;

    WRLDMapOptions* m_mapOptions;
    NSNumber* m_startLocationLatitude;
    NSNumber* m_startLocationLongitude;
    NSNumber* m_startZoomLevel;
    NSNumber* m_startDirection;

    std::unordered_map<WRLDOverlayId, id<WRLDOverlay>, WRLDOverlayIdHash, WRLDOverlayIdEqual> m_overlays;
}



const NSUInteger targetFrameInterval = 1;

const double defaultStartZoomLevel = 8;



- (instancetype)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder])
    {
        m_mapOptions = NULL;
        [self initView];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        m_mapOptions = NULL;
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                andMapOptions:(WRLDMapOptions *)mapOptions
{
    if (self = [super initWithFrame:frame])
    {
        m_mapOptions = mapOptions;
        [self initView];
    }
    
    return self;
}


- (BOOL)isAppBackgrounded
{
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}


- (void)initView
{
    _glContext = nil;
    _displayLink = nil;
    _apiGestureDelegate = nil;
    _nativeMapView = nil;
    _glkView = nil;

    m_pApiRunner = NULL;

    m_startLocationLatitude = nil;
    m_startLocationLongitude = nil;
    m_startZoomLevel = nil;
    m_startDirection = nil;

    m_overlays = {};

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];


    if ([self isAppBackgrounded])
    {
        return;
    }


    // don't create if app is being launched into background - we need a GLES context, only get this when applicationDidBecomeActive
    [self createPlatform];

    Eegeo_ASSERT(m_pApiRunner != NULL);


    [self refreshDisplayLink];

    [self _initialiseCameraView];
    
    [self _initialiseBlueSphere];

    Eegeo::ApiHost::IEegeoApiHost& apiHost = m_pApiRunner->GetEegeoApiHostModule()->GetEegeoApiHost();
    apiHost.OnStart();
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // awakeFromNib after IBAdditions properties have been set from 
    [self _initialiseCameraView];
}

- (void)_initialiseCameraView
{
    Eegeo::Api::EegeoCameraApi& cameraApi = [self getMapApi].GetCameraApi();
    
    // require both latitude and longitude IB properties to be set
    const bool hasStartLocation = (m_startLocationLatitude != nil && m_startLocationLongitude != nil);
    
    const double latitude = hasStartLocation ? [self startLatitude] : 0.0;
    const double longitude = hasStartLocation ? [self startLongitude] : 0.0;
    const double startZoomLevel = [self startZoomLevel];
    const double heading = [self startDirection];
    
    const auto& cameraUpdate = Eegeo::Api::MapCameraUpdateBuilder()
        .SetCoordinate(latitude, longitude)
        .SetZoomLevel(startZoomLevel)
        .SetBearing(heading)
        .Build();
    
    cameraApi.MoveCamera(cameraUpdate);
}

- (void)_initialiseBlueSphere
{
    _blueSphere = [[WRLDBlueSphere alloc] initWithMapView:self];
}

- (void)createPlatform
{
    Eegeo_ASSERT(![self isAppBackgrounded]);

    [self createGLContextAndView];

    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    std::string frameworkBundleId = [[frameworkBundle bundleIdentifier] UTF8String];

    m_pApiRunner = Eegeo::ApiHost::iOS::iOSApiRunner::Create([self getPlatformConfigOptions], frameworkBundleId, _glkView);

    const Eegeo::Rendering::ScreenProperties& screenProperties = m_pApiRunner->GetDisplayScreenProperties();

    _apiGestureDelegate = [[WRLDGestureDelegate alloc] initWith:&(m_pApiRunner->GetEegeoApiHostModule()->GetTouchController())
                                                                      :screenProperties.GetScreenWidth()
                                                                      :screenProperties.GetScreenHeight()
                                                                      :screenProperties.GetPixelScale()
                               ];

    [_apiGestureDelegate bind:self];

    _nativeMapView = Eegeo_NEW(WRLDNativeMapView)(self, *m_pApiRunner);
}

- (Eegeo::ApiHost::EegeoApiHostPlatformConfigOptions)getPlatformConfigOptions
{
    std::string apiKey = [[WRLDApi apiKey] UTF8String];
    std::string coverageTreeManifest, environmentThemesManifest;
    
    if (m_mapOptions != NULL)
    {
        coverageTreeManifest = [m_mapOptions.coverageTreeManifest UTF8String];
        environmentThemesManifest = [m_mapOptions.environmentThemesManifest UTF8String];
    }
    const std::vector<double> cameraZoomLevelDistances;
    Eegeo::ApiHost::EegeoApiHostPlatformConfigOptions configOptions(apiKey, coverageTreeManifest, environmentThemesManifest, cameraZoomLevelDistances);
    
    return configOptions;
}


- (void)onAppWillEnterForeground
{
    if (m_pApiRunner == NULL)
    {
        return;
    }

    [self resume];
}

- (void)onAppDidBecomeActive
{
    if (m_pApiRunner == NULL)
    {
        [self createPlatform];
    }

    [self resume];
}

- (void)onAppDidEnterBackground
{
    if (m_pApiRunner == NULL)
    {
        return;
    }

    [self pause];
}

- (void)onAppWillTerminate
{

}

- (void)onDeviceOrientationDidChange
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    m_pApiRunner->NotifyViewFrameChanged();
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)dealloc
{
    [self commonTeardown];
    
}

- (void)commonTeardown
{
    [self refreshDisplayLink];

    [_glkView deleteDrawable];

    _glkView = nil;

    if ([EAGLContext currentContext] == _glContext)
    {
        [EAGLContext setCurrentContext:nil];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    Eegeo_DELETE _nativeMapView;
    Eegeo_DELETE m_pApiRunner;
}

- (void)resume
{
    Eegeo_ASSERT(m_pApiRunner != NULL);

    if (!m_pApiRunner->IsPaused())
    {
        return;
    }

    if ([self isAppBackgrounded])
    {
        return;
    }

    _displayLink.paused = NO;


    m_pApiRunner->Resume();
}

- (void)pause
{
    Eegeo_ASSERT(m_pApiRunner != NULL);

    if (m_pApiRunner->IsPaused())
    {
        return;
    }

    _displayLink.paused = YES;

    [_glkView deleteDrawable];


    m_pApiRunner->Pause();
}


-(void) removeFromSuperview
{
    [super removeFromSuperview];
}

- (void)createGLContextAndView
{
    Eegeo_ASSERT(_glContext == nil);
    Eegeo_ASSERT(_glkView == nil);


    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    Eegeo_ASSERT(_glContext != nil, "Failed to create OpenGLES2 context");

    [EAGLContext setCurrentContext: _glContext];

    _glkView = [[GLKView alloc] initWithFrame:self.bounds context:_glContext];
    _glkView.delegate = self;
    _glkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _glkView.opaque = YES;

    [self addSubview:_glkView];
}


-(void)refreshDisplayLink
{
    bool doesExist = _displayLink != nil;
    bool shouldExist = self.window && self.superview;
    if (shouldExist == doesExist)
    {
        return;
    }
    else if (doesExist)
    {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    else
    {
        Eegeo_ASSERT(_displayLink == nil);
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateGlViewFromDisplayLink:)];
        _displayLink.frameInterval = targetFrameInterval;

        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _prevDisplayLinkTimestamp = _displayLink.timestamp;
    }
}

- (void)didMoveToWindow
{
    [self refreshDisplayLink];
    [super didMoveToWindow];
}

- (void)didMoveToSuperview
{
    [self refreshDisplayLink];
    [super didMoveToSuperview];
}

- (void) updateGlViewFromDisplayLink:(CADisplayLink*)sender
{
    // mark GLKView as ready for draw on message from vsync-locked CADisplayLink
    [_glkView setNeedsDisplay];
}

- (void)glkView:(__unused GLKView *)view drawInRect:(__unused CGRect)rect
{
    Eegeo_ASSERT(m_pApiRunner != NULL);
    //CFTimeInterval timeNow = CFAbsoluteTimeGetCurrent();

    // _displayLink.timestamp is the time at which the previous frame was displayed
    const double maxFrameDelta = (4.0 * _displayLink.frameInterval) / 60.0;
    double displayLinkDelta = std::min(maxFrameDelta, (_displayLink.timestamp - _prevDisplayLinkTimestamp));

    _prevDisplayLinkTimestamp = _displayLink.timestamp;

    //Eegeo_TTY("displayLinkDelta %f, duration = %f", displayLinkDelta, _displayLink.duration);

    m_pApiRunner->Update(static_cast<float>(displayLinkDelta));
}


- (Eegeo::Api::EegeoMapApi&)getMapApi
{
    Eegeo::Api::EegeoMapApi& mapApi = m_pApiRunner->GetEegeoApiHostModule()->GetEegeoMapApi();
    return mapApi;
}

#pragma mark - public interface implementation -

- (CLLocationCoordinate2D)centerCoordinate
{
    const auto& mapCameraPosition = [self getMapApi].GetCameraApi().GetMapCameraPosition();
    return CLLocationCoordinate2DMake(mapCameraPosition.GetLatitudeDegrees(), mapCameraPosition.GetLongitudeDegrees());
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self setCenterCoordinate:coordinate
                    zoomLevel:[self zoomLevel]
                    direction:[self direction]
                     animated:NO];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    [self setCenterCoordinate:coordinate
                    zoomLevel:[self zoomLevel]
                    direction:[self direction]
                     animated:animated];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated
{
    [self setCenterCoordinate:coordinate
                    zoomLevel:zoomLevel
                    direction:[self direction]
                     animated:animated];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  direction:(CLLocationDirection)direction
                   animated:(BOOL)animated
{
    [self setCenterCoordinate:coordinate
                    zoomLevel:[self zoomLevel]
                    direction:direction
                     animated:animated];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                  direction:(CLLocationDirection)direction
                   animated:(BOOL)animated
{
    [self _setCenterCoordinate:coordinate
                     zoomLevel:zoomLevel
                     direction:direction
                      animated:animated];
}

- (double)zoomLevel
{
    return [self getMapApi].GetCameraApi().GetZoomLevel();
}

- (void)setZoomLevel:(double)zoomLevel
{
    [self setZoomLevel:zoomLevel animated:NO];
}

- (void)setZoomLevel:(double)zoomLevel animated:(BOOL)animated
{
    [self _setCenterCoordinate:[self centerCoordinate]
                     zoomLevel:zoomLevel
                     direction:[self direction]
                      animated:animated];
}

- (CLLocationDirection)direction
{
    const auto& mapCameraPosition = [self getMapApi].GetCameraApi().GetMapCameraPosition();
    return mapCameraPosition.GetBearingDegrees();
}

- (void)setDirection:(CLLocationDirection)direction
{
    [self setDirection:direction animated:NO];
}

- (void)setDirection:(CLLocationDirection)direction animated:(BOOL)animated
{
    [self _setCenterCoordinate:[self centerCoordinate]
                     zoomLevel:[self zoomLevel]
                     direction:direction
                      animated:animated];
}

- (void)_moveOrAnimateCamera:(BOOL)animated mapCameraUpdate:(Eegeo::Api::MapCameraUpdate)mapCameraUpdate
{
    Eegeo::Api::EegeoCameraApi& cameraApi = [self getMapApi].GetCameraApi();
    
    if(animated)
    {
        cameraApi.AnimateCamera(mapCameraUpdate, Eegeo::Api::MapCameraAnimationOptionsBuilder().Build());
    }
    else
    {
        cameraApi.MoveCamera(mapCameraUpdate);
    }
}

- (void)_setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                   zoomLevel:(double)zoomLevel
                   direction:(CLLocationDirection)direction
                    animated:(BOOL)animated
{
    const auto& mapCameraUpdate = Eegeo::Api::MapCameraUpdateBuilder()
        .SetCoordinate(coordinate.latitude, coordinate.longitude)
        .SetBearing(direction)
        .SetZoomLevel(zoomLevel)
        .Build();
    
    [self _moveOrAnimateCamera:animated mapCameraUpdate:mapCameraUpdate];
}

- (void)setCoordinateBounds:(WRLDCoordinateBounds)bounds animated:(BOOL)animated
{
    const auto& northEast = Eegeo::Space::LatLongAltitude::FromDegrees(bounds.ne.latitude, bounds.ne.longitude, 0.0);
    const auto& southWest = Eegeo::Space::LatLongAltitude::FromDegrees(bounds.sw.latitude, bounds.sw.longitude, 0.0);
    
    const auto& mapCameraUpdate = Eegeo::Api::MapCameraUpdateBuilder()
        .MakeForLatLongBounds(northEast.GetLatLong(), southWest.GetLatLong())
        .Build();
    
    [self _moveOrAnimateCamera:animated mapCameraUpdate:mapCameraUpdate];
}

- (WRLDMapCamera *)camera
{
    Eegeo::Api::EegeoCameraApi& cameraApi = [self getMapApi].GetCameraApi();
    const auto& mapCameraPosition = cameraApi.GetMapCameraPosition();
    const auto& centerCoord = CLLocationCoordinate2DMake(mapCameraPosition.GetLatitudeDegrees(), mapCameraPosition.GetLongitudeDegrees());

    return [WRLDMapCamera cameraLookingAtCenterCoordinateIndoors:centerCoord
                                                    fromDistance:mapCameraPosition.GetDistanceToInterest()
                                                           pitch:static_cast<CGFloat>(mapCameraPosition.GetZenithAngleDegrees())
                                                         heading:mapCameraPosition.GetBearingDegrees()
                                                       elevation:mapCameraPosition.GetElevation()
                                                   elevationMode:static_cast<WRLDElevationMode>(mapCameraPosition.GetElevationMode())
                                                     indoorMapId:[NSString stringWithUTF8String:mapCameraPosition.GetIndoorMapId().c_str()]
                                                indoorMapFloorId:mapCameraPosition.GetIndoorMapFloorId()
            ];
}

- (void)setCamera:(WRLDMapCamera *)camera
{
    [self setCamera:camera animated:NO];
}

const Eegeo::Positioning::ElevationMode::Type ToPositioningElevationMode(WRLDElevationMode elevationMode)
{
    return (elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveGround)
        ? Eegeo::Positioning::ElevationMode::HeightAboveGround
        : Eegeo::Positioning::ElevationMode::HeightAboveSeaLevel;
}

+ (Eegeo::Api::MapCameraUpdate)buildMapCameraUpdateFromCamera:(WRLDMapCamera*)camera
{
    const auto& mapCameraUpdate = Eegeo::Api::MapCameraUpdateBuilder()
        .SetCoordinate(camera.centerCoordinate.latitude, camera.centerCoordinate.longitude)
        .SetBearing(camera.heading)
        .SetDistanceToInterest(camera.distance)
        .SetZenithAngle(camera.pitch)
        .SetElevation(camera.elevation)
        .SetElevationMode(ToPositioningElevationMode(camera.elevationMode))
        .SetIndoorMap([camera.indoorMapId UTF8String], static_cast<int>(camera.indoorMapFloorId))
        .Build();
    
    return mapCameraUpdate;
}

- (void)setCamera:(WRLDMapCamera *)camera animated:(BOOL)animated
{
    const auto& mapCameraUpdate = [WRLDMapView buildMapCameraUpdateFromCamera:camera];
    [self _moveOrAnimateCamera:animated mapCameraUpdate:mapCameraUpdate];
}

- (void)setCamera:(WRLDMapCamera *)camera duration:(NSTimeInterval)duration
{
    Eegeo::Api::EegeoCameraApi& cameraApi = [self getMapApi].GetCameraApi();
    const auto& mapCameraUpdate = [WRLDMapView buildMapCameraUpdateFromCamera:camera];
    
    const bool animated = duration > 0;
    
    if(animated)
    {
        cameraApi.AnimateCamera(mapCameraUpdate, Eegeo::Api::MapCameraAnimationOptionsBuilder().SetDuration(duration)
                                                                                                .Build());
    }
    else
    {
        cameraApi.MoveCamera(mapCameraUpdate);
    }
}

#pragma mark - markers -

- (void)addMarker:(WRLDMarker *)marker
{
    [self addOverlay: marker];
}

- (void)addMarkers:(NSArray <WRLDMarker *> *)markers
{
    for (WRLDMarker* marker in markers)
    {
        [self addMarker:marker];
    }
}

- (void)removeMarker:(WRLDMarker *)marker
{
    [self removeOverlay: marker];
}

- (void)removeMarkers:(NSArray <WRLDMarker *> *)markers
{
    for (WRLDMarker* marker in markers)
    {
        [self removeMarker:marker];
    }
}

#pragma mark - positioners -

- (void)addPositioner:(WRLDPositioner *)positioner
{
    [self addOverlay: positioner];
}

- (void)removePositioner:(WRLDPositioner *)positioner
{
    [self removeOverlay: positioner];
}

#pragma mark - polygons -

- (void)addPolygon:(WRLDPolygon *)polygon
{
    [self addOverlay: polygon];
}

- (void)addPolygons:(NSArray <WRLDPolygon *> *)polygons
{
    for (WRLDPolygon* polygon in polygons)
    {
        [self addPolygon:polygon];
    }
}

- (void)removePolygon:(WRLDPolygon *)polygon
{
    [self removeOverlay: polygon];
}

- (void)removePolygons:(NSArray <WRLDPolygon *> *)polygons
{
    for (WRLDPolygon* polygon in polygons)
    {
        [self removePolygon:polygon];
    }
}

#pragma mark - building highlights -

- (void)addBuildingHighlight:(WRLDBuildingHighlight*) buildingHighlight
{
    [self addOverlay:buildingHighlight];
}

- (void)removeBuildingHighlight:(WRLDBuildingHighlight*) buildingHighlight
{
    [self removeOverlay: buildingHighlight];
}

#pragma mark - Feature Picking -

-(WRLDPickResult*)pickFeatureAtScreenPoint:(CGPoint)screenPoint
{
    Eegeo::Api::EegeoPickingApi& pickingApi = [self getMapApi].GetPickingApi();
    Eegeo::Api::PickResult pickResult = pickingApi.PickFeatureAtScreenPoint(Eegeo::v2(static_cast<float>(screenPoint.x),
                                                                                      static_cast<float>(screenPoint.y)));

    return [WRLDPickingApiHelpers createWRLDPickResult:pickResult];
}

-(WRLDPickResult*)pickFeatureAtLocation:(CLLocationCoordinate2D)location
{
    Eegeo::Api::EegeoPickingApi& pickingApi = [self getMapApi].GetPickingApi();
    Eegeo::Api::PickResult pickResult = pickingApi.PickFeatureAtLatLong(Eegeo::Space::LatLong::FromDegrees(location.latitude, location.longitude));

    return [WRLDPickingApiHelpers createWRLDPickResult:pickResult];
}

#pragma mark - overlays -

- (void) addOverlay:(NSObject<WRLDOverlay>*) overlay
{
    if (![overlay conformsToProtocol:@protocol(WRLDOverlayImpl)])
    {
        return;
    }
    id<WRLDOverlayImpl> overlayImpl = (id<WRLDOverlayImpl>)(overlay);
    
    [overlayImpl createNative: [self getMapApi]];
    
    m_overlays[[overlayImpl getOverlayId]] = overlay;
}

- (void) removeOverlay:(NSObject<WRLDOverlay>*) overlay
{
    if (![overlay conformsToProtocol:@protocol(WRLDOverlayImpl)])
    {
        return;
    }
    id<WRLDOverlayImpl> overlayImpl = (id<WRLDOverlayImpl>)(overlay);
    
    m_overlays.erase([overlayImpl getOverlayId]);

    [overlayImpl destroyNative];
}


#pragma mark - controlling the indoor map view -

- (void)enterIndoorMap:(NSString*)indoorMapId
{
    const std::string interiorId = std::string([indoorMapId UTF8String]);
    [self getMapApi].GetIndoorsApi().EnterIndoorMap(interiorId);
}

- (void)exitIndoorMap
{
    [self getMapApi].GetIndoorsApi().ExitIndoorMap();
}

- (BOOL)isIndoors
{
    return [self getMapApi].GetIndoorsApi().HasActiveIndoorMap();
}

- (void) refreshActiveIndoorMap
{
    if ([self isIndoors])
    {
        const Eegeo::Api::EegeoIndoorMapData& indoorMapData = [self getMapApi].GetIndoorsApi().GetIndoorMapData();

        NSString* indoorMapId = [NSString stringWithCString:indoorMapData.indoorMapId.c_str() encoding:[NSString defaultCStringEncoding]];
        NSString* indoorMapName = [NSString stringWithCString:indoorMapData.indoorMapName.c_str() encoding:[NSString defaultCStringEncoding]];
        NSMutableArray<WRLDIndoorMapFloor*>* floors = [NSMutableArray array];
        for (int i=0; i<indoorMapData.floorCount; ++i)
        {
            const Eegeo::Api::EegeoIndoorMapFloorData& floorData = indoorMapData.floors[i];
            NSString* floorId = [NSString stringWithCString:floorData.floorId.c_str() encoding:[NSString defaultCStringEncoding]];
            NSString* floorName = [NSString stringWithCString:floorData.floorName.c_str() encoding:[NSString defaultCStringEncoding]];
            NSInteger floorIndex = static_cast<int>(floorData.floorNumber);

            WRLDIndoorMapFloor* floor = [[WRLDIndoorMapFloor alloc] initWithId:floorId name:floorName floorIndex:floorIndex];
            [floors addObject:floor];
        }
        NSString* userData = [NSString stringWithCString:indoorMapData.userData.c_str() encoding:[NSString defaultCStringEncoding]];

        WRLDIndoorMap* indoorMap = [[WRLDIndoorMap alloc] initWithId:indoorMapId name:indoorMapName floors:[floors copy] userData:userData];

        _activeIndoorMap = indoorMap;
    }
    else
    {
        _activeIndoorMap = nil;
    }
}

- (NSInteger)currentFloorIndex
{
    int currentFloor = [self isIndoors] ? [self getMapApi].GetIndoorsApi().GetSelectedFloorIndex() : -1;
    return static_cast<NSInteger>(currentFloor);
}

- (void)setFloorByIndex:(NSInteger)floorIndex
{
    NSInteger previousFloor = [self currentFloorIndex];
    [self getMapApi].GetIndoorsApi().SetSelectedFloorIndex(static_cast<int>(floorIndex));
    
    if (previousFloor != floorIndex)
    {
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @(previousFloor), WRLDMapViewNotificationPreviousFloorIndex,
                                  @(floorIndex), WRLDMapViewNotificationCurrentFloorIndex,
                                  nil];
        [center postNotificationName:WRLDMapViewDidChangeFloorNotification
                              object:self userInfo: userInfo];
    }
}

- (void)setFloorInterpolation:(CGFloat)floorInterpolation
{
    Eegeo::Resources::Interiors::InteriorInteractionModel& interactionModel = [self getMapApi].GetExpandFloorsApi().GetInteriorInteractionModel();
    interactionModel.SetFloorParam(static_cast<float>(floorInterpolation));
}

- (void)moveUpFloors:(NSInteger)numberOfFloors
{
    NSInteger currentFloor = [self currentFloorIndex];
    if (currentFloor != -1)
    {
        [self setFloorByIndex:(currentFloor + numberOfFloors)];
    }
}

- (void)moveDownFloors:(NSInteger)numberOfFloors
{
    [self moveUpFloors:-numberOfFloors];
}

- (void)moveUpFloor
{
    [self moveUpFloors:1];
}

- (void)moveDownFloor
{
    [self moveDownFloors:1];
}

- (void)expandIndoorMapView
{
    Eegeo::Resources::Interiors::InteriorInteractionModel& interactionModel = [self getMapApi].GetExpandFloorsApi().GetInteriorInteractionModel();
    if (interactionModel.CanExpand())
    {
        interactionModel.ToggleExpanded();
    }
}

- (void)collapseIndoorMapView
{
    Eegeo::Resources::Interiors::InteriorInteractionModel& interactionModel = [self getMapApi].GetExpandFloorsApi().GetInteriorInteractionModel();
    if (!interactionModel.CanExpand())
    {
        interactionModel.ToggleExpanded();
    }
}

- (void)setIndoorEntityHighlights:(NSString*)indoorMapId indoorEntityIds:(NSArray<NSString*>*)indoorEntityIds color:(UIColor*) color
{
    Eegeo::Api::EegeoIndoorEntityApi& indoorEntityApi = [self getMapApi].GetIndoorEntityApi();
    indoorEntityApi.SetHighlights(std::string([indoorMapId UTF8String]),
                                  [WRLDStringApiHelpers copyToStringVector:indoorEntityIds],
                                  [WRLDMathApiHelpers getEegeoColor:color]);
}

- (void)clearIndoorEntityHighlights:(NSString*)indoorMapId indoorEntityIds:(NSArray<NSString*>*)indoorEntityIds
{
    Eegeo::Api::EegeoIndoorEntityApi& indoorEntityApi = [self getMapApi].GetIndoorEntityApi();
    indoorEntityApi.ClearHighlights(std::string([indoorMapId UTF8String]),
                                    [WRLDStringApiHelpers copyToStringVector:indoorEntityIds]);
}

- (void)clearAllIndoorEntityHighlights
{
    Eegeo::Api::EegeoIndoorEntityApi& indoorEntityApi = [self getMapApi].GetIndoorEntityApi();
    indoorEntityApi.ClearAllHighlights();
}

- (void)setMapCollapsed:(BOOL)isMapCollapsed
{
    [self getMapApi].GetRenderingApi().SetMapCollapsed(isMapCollapsed);
}

#pragma mark - POI search service

- (WRLDPoiService*)createPoiService
{
    return [[WRLDPoiService alloc] initWithApi: [self getMapApi].GetPoiApi() ];
}

#pragma mark - Mapscene service

- (WRLDMapsceneService*)createMapsceneService
{
    return [[WRLDMapsceneService alloc] initWithApi: [self getMapApi].GetMapsceneApi() ];
}

#pragma mark - Routing service

- (WRLDRoutingService*)createRoutingService
{
    return [[WRLDRoutingService alloc] initWithApi: [self getMapApi].GetRoutingApi() ];
    
}

#pragma mark - WRLDMapView (Private)
    
    
- (void)notifyMapViewRegionWillChange
{
    if ([self.delegate respondsToSelector:@selector(mapViewRegionWillChange:)])
    {
        [self.delegate mapViewRegionWillChange:self];
    }
}
    
- (void)notifyMapViewRegionIsChanging
{
    if ([self.delegate respondsToSelector:@selector(mapViewRegionIsChanging:)])
    {
        [self.delegate mapViewRegionIsChanging:self];
    }
}

- (void)notifyMapViewRegionDidChange
{
    if ([self.delegate respondsToSelector:@selector(mapViewRegionDidChange:)])
    {
        [self.delegate mapViewRegionDidChange:self];
    }
}
    
-(void)notifyInitialStreamingCompleted
{
    if ([self.delegate respondsToSelector:@selector(mapViewDidFinishLoadingInitialMap:)])
    {
        [self.delegate mapViewDidFinishLoadingInitialMap:self];
    }
}

-(void)notifyTouchTapped:(CGPoint)point
{
    Boolean respondsToDidTapMap = [self.delegate respondsToSelector:@selector(mapView:didTapMap:)];
    Boolean respondsToDidTapView = [self.delegate respondsToSelector:@selector(mapView:didTapView:)];

    if (respondsToDidTapMap || respondsToDidTapView)
    {
        Eegeo::Api::EegeoSpacesApi& spacesApi = [self getMapApi].GetSpacesApi();
        
        Eegeo::v2 p = Eegeo::v2(static_cast<float>(point.x), static_cast<float>(point.y));
        Eegeo::Space::LatLongAltitude lla(0.0, 0.0, 0.0);
        
        bool success = spacesApi.TryGetScreenToTerrainPoint(p, lla);
        
        if (success)
        {
            WRLDCoordinateWithAltitude coordinateWithAltitude = WRLDCoordinateWithAltitudeMake(CLLocationCoordinate2DMake(lla.GetLatitudeInDegrees(), lla.GetLongitudeInDegrees()), lla.GetAltitude());

            if (respondsToDidTapMap)
            {
                [self.delegate mapView:self didTapMap:coordinateWithAltitude];
            }

            if (respondsToDidTapView)
            {
                WRLDTouchTapInfo tapInfo = WRLDTouchTapInfoMake(point, coordinateWithAltitude);

                [self.delegate mapView:self didTapView:tapInfo];
            }
        }
    }
}

template<typename T> inline T* safe_cast(id instance)
{
    if ([instance isKindOfClass:[T class]])
    {
        return static_cast<T*>(instance);
    }
    return nil;
}

- (void)notifyMarkerTapped:(int)markerId
{
    WRLDOverlayId overlayId;
    overlayId.overlayType = WRLDOverlayMarker;
    overlayId.nativeHandle = markerId;
    
    if (m_overlays.find(overlayId) == m_overlays.end())
    {
        return;
    }
    
    id<WRLDOverlay> overlay = m_overlays.at(overlayId);

    WRLDMarker* marker = safe_cast<WRLDMarker>(overlay);
    if (marker == nil)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(mapView:didTapMarker:)])
    {
        [self.delegate mapView:self didTapMarker:marker];
    }
}

- (void)notifyPositionerProjectionChanged
{
    if ([self.delegate respondsToSelector:@selector(mapView:positionerDidChange:)])
    {
        for(auto i=m_overlays.begin(); i!=m_overlays.end(); ++i)
        {
            WRLDPositioner* positioner = safe_cast<WRLDPositioner>(i->second);
            if (positioner != nil)
            {
                [self.delegate mapView:self positionerDidChange:positioner];
            }
        }
    }
}

- (void)notifyEnteredIndoorMap
{
    [self refreshActiveIndoorMap];
    
    if ([self.indoorMapDelegate respondsToSelector:@selector(didEnterIndoorMap)])
    {
        [self.indoorMapDelegate didEnterIndoorMap];
    }
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:WRLDMapViewDidEnterIndoorMapNotification object:self];
}

- (void)notifyExitedIndoorMap
{
    [self refreshActiveIndoorMap];
    
    if ([self.indoorMapDelegate respondsToSelector:@selector(didExitIndoorMap)])
    {
        [self.indoorMapDelegate didExitIndoorMap];
    }
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:WRLDMapViewDidExitIndoorMapNotification object:self];
}

- (void)notifyPoiSearchCompleted:(const Eegeo::PoiSearch::PoiSearchResults&)result
{
    WRLDPoiSearchResponse* poiSearchResponse = [[WRLDPoiSearchResponse alloc] init];
    [poiSearchResponse setSucceeded: result.Succeeded];
    poiSearchResponse.results = [[NSMutableArray alloc] initWithCapacity:(result.Results.size())];
    for(auto& poi : result.Results)
    {
        WRLDPoiSearchResult* searchResult = [[WRLDPoiSearchResult alloc] init];
        
        [searchResult setId: poi.Id];
        [searchResult setTitle: [NSString stringWithCString: poi.Title.c_str() encoding:NSUTF8StringEncoding]];
        [searchResult setSubtitle: [NSString stringWithCString: poi.Subtitle.c_str() encoding:NSUTF8StringEncoding]];
        [searchResult setTags: [NSString stringWithCString: poi.Tags.c_str() encoding:NSUTF8StringEncoding]];
        [searchResult setLatLng: CLLocationCoordinate2DMake(poi.LatLong.GetLatitudeInDegrees(), poi.LatLong.GetLongitudeInDegrees())];
        [searchResult setHeightOffset: poi.HeightOffset];
        [searchResult setIndoor: poi.Indoor];
        [searchResult setIndoorMapId: [NSString stringWithCString: poi.IndoorId.c_str() encoding:NSUTF8StringEncoding]];
        [searchResult setIndoorMapFloorId: poi.FloorId];
        [searchResult setUserData: [NSString stringWithCString: poi.UserData.c_str() encoding:NSUTF8StringEncoding]];

        [poiSearchResponse.results addObject:searchResult];
    }

    [self.delegate mapView:self poiSearchDidComplete:result.Id poiSearchResponse:poiSearchResponse];
}

- (void)notifyMapsceneCompleted:(const Eegeo::Mapscenes::MapsceneRequestResponse&)result
{
    WRLDMapsceneRequestResponse* response = [WRLDMapsceneServiceHelpers createWRLDMapsceneRequestResponse:result];
    Eegeo::Api::EegeoCameraApi& cameraApi = [self getMapApi].GetCameraApi();
    
    // Application of starting position
    // TODO: Move to platform once camera API update is concluded.
    if(result.Success())
    {
        WRLDMapsceneStartLocation* startLocation = response.mapscene.startLocation;
        
        const auto& mapCameraUpdate = Eegeo::Api::MapCameraUpdateBuilder()
            .SetCoordinate(startLocation.coordinate.latitude, startLocation.coordinate.longitude)
            .SetBearing(startLocation.heading)
            .SetDistanceToInterest(startLocation.distance)
            .SetIndoorMap([startLocation.interiorId UTF8String], startLocation.interiorFloorIndex)
            .Build();
        
        cameraApi.MoveCamera(mapCameraUpdate);
    }
    
    [self.delegate mapView:self mapsceneRequestDidComplete:result.GetRequestId() mapsceneResponse:response];
}

- (void)notifyRoutingQueryCompleted:(const Eegeo::Routes::Webservice::RoutingQueryResponse&)result
{
    WRLDRoutingQueryResponse* routingQueryResponse = [WRLDRoutingServiceHelpers createWRLDRoutingQueryResponse:result];

    [self.delegate mapView:self routingQueryDidComplete:result.Id routingQueryResponse:routingQueryResponse];
}

- (void)notifyBuildingInformationReceived:(int)buildingHighlightId
{
    WRLDOverlayId overlayId;
    overlayId.overlayType = WRLDOverlayBuildingHighlight;
    overlayId.nativeHandle = buildingHighlightId;

    if (m_overlays.find(overlayId) == m_overlays.end())
    {
        return;
    }

    id<WRLDOverlay> overlay = m_overlays.at(overlayId);

    WRLDBuildingHighlight* buildingHighlight = safe_cast<WRLDBuildingHighlight>(overlay);

    if (buildingHighlight == nil)
    {
        return;
    }

    [buildingHighlight loadBuildingInformationFromNative];

    if ([self.delegate respondsToSelector:@selector(mapView:didReceiveBuildingInformationForHighlight:)])
    {
        [self.delegate mapView:self didReceiveBuildingInformationForHighlight:buildingHighlight];
    }
}

- (void)notifyIndoorEntityTapped:(const Eegeo::Api::IndoorEntityPickedMessage&)indoorEntityPickedMessage
{
    if ([self.delegate respondsToSelector:@selector(mapView:didTapIndoorEntities:)])
    {
        [self.delegate mapView:self didTapIndoorEntities:[WRLDIndoorEntityApiHelpers createIndoorEntityTapResult:indoorEntityPickedMessage
                                                                                                     indoorMapId:_activeIndoorMap.indoorId]];
    }
}

@end


#pragma mark - IBAdditions implementation -

@implementation WRLDMapView (IBAdditions)


- (double)startLatitude
{
    return (m_startLocationLatitude != nil) ? m_startLocationLatitude.doubleValue : 0.0;
}

- (double)startLongitude
{
    return (m_startLocationLongitude != nil) ? m_startLocationLongitude.doubleValue : 0.0;
}

- (double)startZoomLevel
{
    return (m_startZoomLevel != nil) ? m_startZoomLevel.doubleValue : defaultStartZoomLevel;
}

- (double)startDirection
{
    return (m_startDirection != nil) ? m_startDirection.doubleValue : 0.0;
}

- (void)setStartLatitude:(double)latitude
{
    m_startLocationLatitude = [NSNumber numberWithDouble:latitude];
}

- (void)setStartLongitude:(double)longitude
{
    m_startLocationLongitude = [NSNumber numberWithDouble:longitude];
}

- (void)setStartZoomLevel:(double)zoomLevel
{
    m_startZoomLevel = [NSNumber numberWithDouble:zoomLevel];
}

- (void)setStartDirection:(double)direction
{
    m_startDirection = [NSNumber numberWithDouble:direction];
}


@end
