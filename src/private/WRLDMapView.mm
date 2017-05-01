
#import "Wrld.h"
#import "WRLDGestureDelegate.h"

#include "iOSApiRunner.h"
#include "iOSGlDisplayService.h"


#include "iOSApiHostModule.h"
#include "EegeoCameraApi.h"
#include "EegeoApiHost.h"

#import <QuartzCore/QuartzCore.h>

@interface WRLDMapView () <GLKViewDelegate>

@property (nonatomic) GLKView *glkView;
@property (nonatomic) EAGLContext *glContext;
@property (nonatomic) WRLDGestureDelegate* apiGestureDelegate;

@property (nonatomic) CADisplayLink* displayLink;

@property (nonatomic) CFTimeInterval prevDisplayLinkTimestamp;
@end


@implementation WRLDMapView
{
    Eegeo::ApiHost::iOS::iOSApiRunner* m_pApiRunner;
}


// todo make configurable? Was previously 2 in ios-api
const NSUInteger targetFrameInterval = 1;




- (instancetype)initWithCoder:(NSCoder*)coder
{
    if(self = [super initWithCoder:coder])
    {
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initView];
    }
    
    return self;
}


-(BOOL)isAppBackgrounded
{
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}


-(void)initView
{
    _glContext = nil;
    _displayLink = nil;
    _apiGestureDelegate = nil;
    _glkView = nil;
    
    m_pApiRunner = NULL;

    
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
    
    const double latitude = 37.7858;
    const double longitude = -122.401;
    const double interestAltitude = 0.0;
    const double distanceToInterest = 1781.0;
    const double bearing = 0.0;
    

    Eegeo::Api::EegeoMapApi& mapApi = m_pApiRunner->GetEegeoApiHostModule()->GetEegeoMapApi();
    Eegeo::ApiHost::IEegeoApiHost& apiHost = m_pApiRunner->GetEegeoApiHostModule()->GetEegeoApiHost();
    
    mapApi.GetCameraApi().InitialiseView(latitude, longitude, interestAltitude, distanceToInterest, bearing, 0.0, false);

    
    apiHost.OnStart();



    // todo - this a test of view delegate. Event needs deferring, ViewController will not have valid ref to this view until after caller returns
    
    if ([self.delegate respondsToSelector:@selector(mapApiCreated:)]) {
        [self.delegate mapApiCreated:self];
    }
  
}



-(void) createPlatform
{
    Eegeo_ASSERT(![self isAppBackgrounded]);
    
    [self createGLContextAndView];
    
    std::string apiKey = [[WRLDApi apiKey] UTF8String];
    
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    std::string frameworkBundleId = [[frameworkBundle bundleIdentifier] UTF8String];
    
    m_pApiRunner = Eegeo::ApiHost::iOS::iOSApiRunner::Create(apiKey, frameworkBundleId, _glkView);
    
    const Eegeo::Rendering::ScreenProperties& screenProperties = m_pApiRunner->GetDisplayScreenProperties();
    
    _apiGestureDelegate = [[WRLDGestureDelegate alloc] initWith:&(m_pApiRunner->GetEegeoApiHostModule()->GetTouchController())
                                                                      :screenProperties.GetScreenWidth()
                                                                      :screenProperties.GetScreenHeight()
                                                                      :screenProperties.GetPixelScale()
                               ];
    
    [_apiGestureDelegate bind:self];
    
    
    
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
    [self commonTeardown];
}

- (void)onDeviceOrientationDidChange
{
    [self setNeedsLayout];
    
    m_pApiRunner->NotifyDeviceOrientationChanged();

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
    [self commonTeardown];
    
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
    
    
    [self _updateViewProperties];
}


- (Eegeo::Api::EegeoMapApi&)getMapApi
{
    Eegeo::Api::EegeoMapApi& mapApi = m_pApiRunner->GetEegeoApiHostModule()->GetEegeoMapApi();
    return mapApi;
}

- (void)_updateViewProperties
{
    Eegeo::Api::EegeoCameraApi& cameraApi = [self getMapApi].GetCameraApi();
    Eegeo::Space::LatLong latLong = cameraApi.GetInterestLatLong();
    
    _centerCoordinate = CLLocationCoordinate2DMake(latLong.GetLatitudeInDegrees(), latLong.GetLongitudeInDegrees());
    _zoomLevel = cameraApi.GetZoomLevel();
    _direction = cameraApi.GetHeadingDegrees();
}

#pragma mark == public interface implementation ==

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    [self setCenterCoordinate:coordinate
                    zoomLevel:[self zoomLevel]
                     animated:animated];
}


- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated
{
    [self setCenterCoordinate:coordinate
                    zoomLevel:[self zoomLevel]
                    direction:[self direction]
                     animated:animated];
}


- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                  direction:(CLLocationDirection)direction
                   animated:(BOOL)animated
{
    [self _setMapCenter:coordinate
              zoomLevel:[self zoomLevel]
              direction:[self direction]
               animated:animated];
}

- (void)_setMapCenter:(CLLocationCoordinate2D)coordinate
            zoomLevel:(double)zoomLevel
            direction:(CLLocationDirection)direction
             animated:(BOOL)animated
{
    Eegeo::Api::EegeoCameraApi& cameraApi = [self getMapApi].GetCameraApi();
    
    double distance = cameraApi.GetDistanceFromZoomLevel(zoomLevel);
    double altitude = 0.0;
    
    const double transitionDurationSeconds = animated ? 10.0 : 0.0;
    const bool hasTransitionDuration = true;
    const bool jumpIfFarAway = true;
    const bool allowInterruption = true;
    
    cameraApi.SetView(animated, coordinate.latitude, coordinate.longitude, altitude, true, distance, true, direction, true, 0.0, false, transitionDurationSeconds, hasTransitionDuration, jumpIfFarAway, allowInterruption);
    
}




@end
