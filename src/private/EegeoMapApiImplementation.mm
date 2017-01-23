// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#import "EegeoMapApiImplementation.h"
#import "EGPolygonImplementation.h"
#import "EGPrecacheOperationImplementation.h"
#import "EGMapDelegate.h"

#include "CameraHelpers.h"
#include "EcefTangentBasis.h"
#include "PinsModule.h"
#include "ITextureFileLoader.h"
#include "RegularTexturePageLayout.h"
#include "AnnotationController.h"
#include "ICityThemesService.h"
#include "ICityThemesUpdater.h"
#include "EnvironmentFlatteningService.h"
#include "ICityThemeRepository.h"
#include "GlobeCameraControllerConfiguration.h"
#include "CityThemesModule.h"

#include "EegeoGeofenceApi.h"
#include "EegeoCameraApi.h"
#include "EegeoAnnotationsApi.h"
#include "EegeoPrecacheApi.h"
#include "EegeoThemesApi.h"

extern "C"
{
    // :TODO: adjust eegeo-api in eegeo-mobile so this is no longer needed.
    void eegeoMapInitializedCallback(int mapId, Eegeo::Api::EegeoMapApi* pMapApi)
    {
        
    }
}

@implementation EegeoMapApiImplementation
{
    Eegeo::EegeoWorld* m_pWorld;
    ExampleApp* m_pApp;
    id<EGMapDelegate> m_delegate;
    Eegeo::Api::EegeoMapApi* m_pApi;
    Eegeo::Api::TGeofenceId m_geofenceIdGenerator;
    Eegeo::Api::AnnotationController* m_pAnnotationController;
}

@synthesize selectedAnnotations = _selectedAnnotations;

// :TODO: reconsider this wiring, feels a bit backwards for the API to depend on the App
- (id)initWithWorld:(Eegeo::EegeoWorld&)world
                app:(ExampleApp&)app
           delegate:(id<EGMapDelegate>)delegate
               view:(UIView*)view
{
    m_pWorld = &world;
    m_pApp = &app;
    m_delegate = delegate;
    m_pApi = &app.GetApi();
    m_geofenceIdGenerator = 0;
    
    Eegeo::Modules::IPlatformAbstractionModule& platformAbstractionModule = m_pWorld->GetPlatformAbstractionModule();
    Eegeo::Modules::Core::RenderingModule& renderingModule = m_pWorld->GetRenderingModule();
    Eegeo::Modules::Map::Layers::TerrainModelModule& terrainModelModule = m_pWorld->GetTerrainModelModule();
    Eegeo::Modules::Map::MapModule& mapModule = m_pWorld->GetMapModule();
    const Eegeo::Rendering::ScreenProperties& initialScreenProperties = m_pApp->GetScreenPropertiesProvider().GetScreenProperties();
    Eegeo::Helpers::ITextureFileLoader& textureFileLoader = platformAbstractionModule.GetTextureFileLoader();
    Eegeo::Resources::Terrain::Heights::TerrainHeightProvider& terrainHeightProvider = m_pWorld->GetMapModule().GetTerrainModelModule().GetTerrainHeightProvider();
    
    m_pAnnotationController = Eegeo_NEW(Eegeo::Api::AnnotationController)(renderingModule,
                                                                          platformAbstractionModule,
                                                                          terrainModelModule,
                                                                          mapModule,
                                                                          initialScreenProperties,
                                                                          textureFileLoader,
                                                                          terrainHeightProvider,
                                                                          view,
                                                                          delegate);
    
    return self;
}

- (void)teardown
{
    Eegeo_DELETE(m_pAnnotationController);
}

- (void)update:(float)dt
{
    Eegeo::Camera::RenderCamera renderCamera(m_pApp->GetGlobeCameraController().GetRenderCamera());
    m_pAnnotationController->Update(dt, renderCamera);
}

- (void)updateScreenProperties:(const Eegeo::Rendering::ScreenProperties&)screenProperties
{
    m_pAnnotationController->UpdateScreenProperties(screenProperties);
}

- (id<EGPolygon>)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
{
    std::vector<Eegeo::Space::LatLongAltitude> verts;
    verts.reserve(count);

    for(int i = 0; i < count; i++)
    {
        const CLLocationCoordinate2D coord = coords[i];
        verts.push_back(Eegeo::Space::LatLongAltitude::FromDegrees(coord.latitude, coord.longitude, 0.0));
    }
    
    Eegeo::Api::EegeoGeofenceApi& api = m_pApi->GetGeofenceApi();
    Eegeo::v4 color(1.0f, 0.0f, 0.0f, 0.5f);
    EGPolygonImplementation* wrapper = [[[EGPolygonImplementation alloc] initWithVerts:verts api:api color:color] autorelease];

    return wrapper;
}

- (void)addPolygon:(id<EGPolygon>)polygon
{
    if([polygon isKindOfClass:[EGPolygonImplementation class]])
    {
        EGPolygonImplementation* pImpl = (EGPolygonImplementation *)polygon;
        [pImpl addToScene];
    }
}

- (void)removePolygon:(id <EGPolygon>)polygon
{
    if([polygon isKindOfClass:[EGPolygonImplementation class]])
    {
        EGPolygonImplementation* pImpl = (EGPolygonImplementation *)polygon;
        [pImpl removeFromScene];
    }
}


- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
             distanceMetres:(float)distanceMetres
         orientationDegrees:(float)orientationDegrees
                   animated:(BOOL)animated
{
    const bool modifyPosition = true;
    const bool modifyDistance = true;
    const bool modifyHeading = true;
    const bool modifyTilt = true;
    const bool jumpIfFarAway = true;
    const bool allowInterruption = false;
    const double transitionDuration = 0.0;
    const bool hasTransitionDuration = false;
    const double altitude = 0.0;
    
    m_pApi->GetCameraApi().SetView(
        !!animated,
        centerCoordinate.latitude, centerCoordinate.longitude, altitude, modifyPosition,
        distanceMetres, modifyDistance,
        orientationDegrees, modifyHeading,
        0.0, modifyTilt,
        transitionDuration, hasTransitionDuration,
        jumpIfFarAway, allowInterruption);
}

- (void)addAnnotation:(id<EGAnnotation>)annotation
{
    m_pAnnotationController->InsertAnnotation(annotation);
}

- (void)selectAnnotation:(id<EGAnnotation>)annotation animated:(BOOL)animated
{
    m_pAnnotationController->SelectAnnotation(annotation, animated);
}

- (void)deselectAnnotation:(id<EGAnnotation>)annotation animated:(BOOL)animated
{
    m_pAnnotationController->DeselectAnnotation(annotation, animated);
}

- (NSArray*)selectedAnnotations
{
    id<EGAnnotation> selectedAnnotation = m_pAnnotationController->SelectedAnnotation();
    return (selectedAnnotation ? @[ selectedAnnotation ] : @[]);
}

- (void)removeAnnotation:(id<EGAnnotation>)annotation
{
    m_pAnnotationController->RemoveAnnotation(annotation);
    m_pAnnotationController->Update(0.f, m_pApp->GetGlobeCameraController().GetRenderCamera());
}

- (EGAnnotationView*)viewForAnnotation:(id<EGAnnotation>)annotation
{
    return m_pAnnotationController->ViewForAnnotation(annotation);
}

- (void)setVisibleCoordinateBounds:(EGCoordinateBounds)bounds animated:(BOOL)animated
{
    const bool allowInterruption = false;
    
    m_pApi->GetCameraApi().SetViewToBounds(
                         Eegeo::Space::LatLongAltitude::FromDegrees(bounds.ne.latitude, bounds.ne.longitude, 0.0),
                         Eegeo::Space::LatLongAltitude::FromDegrees(bounds.sw.latitude, bounds.sw.longitude, 0.0),
                         !!animated,
                         allowInterruption);
}

- (id<EGPrecacheOperation>)precacheMapDataInCoordinateBounds:(EGCoordinateBounds)bounds
{
    Eegeo::dv3 ne = Eegeo::Space::LatLong::FromDegrees(bounds.ne.latitude, bounds.ne.longitude).ToECEF();
    Eegeo::dv3 sw = Eegeo::Space::LatLong::FromDegrees(bounds.sw.latitude, bounds.sw.longitude).ToECEF();
    Eegeo::dv3 ecefCenter = (ne + sw) / 2.0;
    double boundingRadius = fmax((ecefCenter - ne).Length(), (ecefCenter - sw).Length());
    
    EGPrecacheOperationImplementation* pEGPrecacheOperation = [[[EGPrecacheOperationImplementation alloc]
                                                                initWithPrecacheService:m_pWorld->GetStreamingModule().GetPrecachingService()
                                                                api:m_pApi->GetPrecacheApi()
                                                                center:ecefCenter
                                                                radius:boundingRadius
                                                                delegate:m_delegate] autorelease];
    [pEGPrecacheOperation start];
    
    return pEGPrecacheOperation;
}

- (void)setMapTheme:(EGMapTheme*)mapTheme
{
    Eegeo::Api::EegeoThemesApi& themesApi = m_pApi->GetThemesApi();
    const float transitionSpeed = 1.0f;
    themesApi.SetTheme([mapTheme.themeName UTF8String]);
    themesApi.SetState([mapTheme.themeStateName UTF8String], transitionSpeed);
}

- (void)setEnvironmentFlatten:(BOOL)flatten
{
    Eegeo::Rendering::EnvironmentFlatteningService& flatteningService = m_pWorld->GetMapModule().GetEnvironmentFlatteningService();
    flatteningService.SetIsFlattened(flatten);
}

- (float)computeAltitudeForRadius:(double)boundingRadius
{
    // This ain't pretty.
    
    float tentativeAltitudeMetres = 0.f;
    float tentativeFovDeg = 60.0f;
    const double minimumAltitude = 500.0;
    const size_t NumIterations = 20;
    
    for(size_t i = 0; i < NumIterations; ++ i)
    {
        const float tentativeFovRad = Eegeo::Math::Deg2Rad(tentativeFovDeg);
        tentativeAltitudeMetres = static_cast<float>(fmax(minimumAltitude, (boundingRadius / tanf(tentativeFovRad/2.f))));
        
        Eegeo::Camera::GlobeCamera::GlobeCameraControllerConfiguration camConfig = Eegeo::Camera::GlobeCamera::GlobeCameraControllerConfiguration::CreateDefault(false);
        
        if(tentativeAltitudeMetres >= camConfig.globeModeBeginFOVChangeAltitude)
        {
            float fovZoomParam = Eegeo::Math::Clamp01((tentativeAltitudeMetres - camConfig.globeModeBeginFOVChangeAltitude) / (camConfig.globeModeEndFOVChangeAltitude - camConfig.globeModeBeginFOVChangeAltitude));
            tentativeFovDeg = Eegeo::Math::Lerp(camConfig.fovZoomedInGlobe, camConfig.fovZoomedOutGlobe, fovZoomParam);
        }
        else
        {
            float fovZoomParam = Eegeo::Math::Clamp01((tentativeAltitudeMetres - camConfig.zoomAltitudeLow) / (camConfig.globeModeBeginFOVChangeAltitude  - camConfig.zoomAltitudeLow));
            tentativeFovDeg = Eegeo::Math::Lerp(camConfig.fovZoomedInCity, camConfig.fovZoomedInGlobe, fovZoomParam);
        }
    }
    
    return tentativeAltitudeMetres;
}

- (BOOL)Event_TouchRotate:(const AppInterface::RotateData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchRotate_Start:(const AppInterface::RotateData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchRotate_End:(const AppInterface::RotateData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPinch:(const AppInterface::PinchData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPinch_Start:(const AppInterface::PinchData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPinch_End:(const AppInterface::PinchData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPan:(const AppInterface::PanData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPan_Start:(const AppInterface::PanData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPan_End:(const AppInterface::PanData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchTap:(const AppInterface::TapData&)data
{
    Eegeo::v2 screenTapPoint = Eegeo::v2(data.point.GetX(), data.point.GetY());
    m_pAnnotationController->HandleTap(screenTapPoint);
    
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchDoubleTap:(const AppInterface::TapData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchDown:(const AppInterface::TouchData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchMove:(const AppInterface::TouchData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchUp:(const AppInterface::TouchData&)data
{
    bool eventConsumed = m_pApi->GetCameraApi().IsTransitioning();
    return eventConsumed;
}

@end