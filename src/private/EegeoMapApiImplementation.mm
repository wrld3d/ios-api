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
#include "CameraTransitioner.h"
#include "PrecacheOperationScheduler.h"
#include "AnnotationController.h"
#include "ICityThemesService.h"
#include "ICityThemesUpdater.h"
#include "EnvironmentFlatteningService.h"
#include "ICityThemeRepository.h"
#include "GlobeCameraControllerConfiguration.h"
#include "CityThemesModule.h"

@implementation EegeoMapApiImplementation
{
    Eegeo::EegeoWorld* m_pWorld;
    ExampleApp* m_pApp;
    id<EGMapDelegate> m_delegate;

    Eegeo::Api::CameraTransitioner* m_pCameraTransitioner;
    Eegeo::Api::PrecacheOperationScheduler m_precacheOperationScheduler;
    Eegeo::Api::AnnotationController* m_pAnnotationController;
}

@synthesize selectedAnnotations = _selectedAnnotations;

- (id)initWithWorld:(Eegeo::EegeoWorld&)world
                app:(ExampleApp&)app
           delegate:(id<EGMapDelegate>)delegate
               view:(UIView*)view
{
    m_pWorld = &world;
    m_pApp = &app;
    m_delegate = delegate;
    
    m_pCameraTransitioner = Eegeo_NEW(Eegeo::Api::CameraTransitioner)(m_pApp->GetGlobeCameraController());
    
    Eegeo::Modules::IPlatformAbstractionModule& platformAbstractioModule = m_pWorld->GetPlatformAbstractionModule();
    Eegeo::Modules::Core::RenderingModule& renderingModule = m_pWorld->GetRenderingModule();
    Eegeo::Modules::Map::Layers::TerrainModelModule& terrainModelModule = m_pWorld->GetTerrainModelModule();
    Eegeo::Modules::Map::MapModule& mapModule = m_pWorld->GetMapModule();
    const Eegeo::Rendering::ScreenProperties& initialScreenProperties = m_pApp->GetScreenPropertiesProvider().GetScreenProperties();
    Eegeo::Helpers::ITextureFileLoader& textureFileLoader = platformAbstractioModule.GetTextureFileLoader();
    Eegeo::Resources::Terrain::Heights::TerrainHeightProvider& terrainHeightProvider = m_pWorld->GetMapModule().GetTerrainModelModule().GetTerrainHeightProvider();
    
    m_pAnnotationController = Eegeo_NEW(Eegeo::Api::AnnotationController)(renderingModule,
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
    Eegeo_DELETE(m_pCameraTransitioner);
    Eegeo_DELETE(m_pAnnotationController);
}

- (void)update:(float)dt
{
    if(m_pCameraTransitioner->IsTransitioning())
    {
        m_pCameraTransitioner->Update(dt);
    }
    
    Eegeo::Camera::RenderCamera renderCamera(m_pApp->GetGlobeCameraController().GetRenderCamera());
    
    m_precacheOperationScheduler.Update();
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

    auto* pModel = Eegeo::Data::Geofencing::GeofenceModel::GeofenceBuilder(
            "test",
            Eegeo::v4(1.0f, 0.0f, 0.0f, 0.5f),
            verts)
            .Build();

    EGPolygonImplementation* wrapper = [[[EGPolygonImplementation alloc] initWithGeofence:*pModel] autorelease];

    return wrapper;
}

- (void)addPolygon:(id<EGPolygon>)polygon
{
    if([polygon isKindOfClass:[EGPolygonImplementation class]])
    {
        EGPolygonImplementation* pImpl = (EGPolygonImplementation *)polygon;

        Eegeo::Data::Geofencing::GeofenceController& geofenceController =
                m_pWorld->GetDataModule().GetGeofenceModule().GetController();

        geofenceController.Add(*pImpl.pGeofenceModel);
    }
}

- (void)removePolygon:(id <EGPolygon>)polygon
{
    if([polygon isKindOfClass:[EGPolygonImplementation class]])
    {
        EGPolygonImplementation* pImpl = (EGPolygonImplementation *)polygon;

        Eegeo::Data::Geofencing::GeofenceController& geofenceController =
                m_pWorld->GetDataModule().GetGeofenceModule().GetController();

        geofenceController.Remove(*pImpl.pGeofenceModel);
    }
}


- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
             distanceMetres:(float)distanceMetres
         orientationDegrees:(float)orientationDegrees
                   animated:(BOOL)animated
{
    Eegeo::Space::LatLongAltitude location = Eegeo::Space::LatLongAltitude::FromDegrees(centerCoordinate.latitude,
                                                                                        centerCoordinate.longitude,
                                                                                        0.f);
    
    if(!animated)
    {
        Eegeo::Space::EcefTangentBasis cameraInterestBasis;
        Eegeo::Camera::CameraHelpers::EcefTangentBasisFromPointAndHeading(location.ToECEF(),
                                                                          orientationDegrees,
                                                                          cameraInterestBasis);
        
        m_pApp->SetCameraView(cameraInterestBasis, distanceMetres);
    }
    else
    {
        m_pCameraTransitioner->StartTransitionTo(location.ToECEF(), distanceMetres, orientationDegrees, true);
    }
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
    Eegeo::dv3 ne = Eegeo::Space::LatLong::FromDegrees(bounds.ne.latitude, bounds.ne.longitude).ToECEF();
    Eegeo::dv3 sw = Eegeo::Space::LatLong::FromDegrees(bounds.sw.latitude, bounds.sw.longitude).ToECEF();
    Eegeo::dv3 center = (ne + sw) / 2.0;
    double boundingRadius = (ne - sw).Length() / 2.0;
    
    const float altitude = [self computeAltitudeForRadius:boundingRadius];
    
    if(animated)
    {
        m_pCameraTransitioner->StartTransitionTo(center, altitude, 0.f, 45.f, true);
    }
    else
    {
        const float currentBearingRads = Eegeo::Camera::CameraHelpers::GetAbsoluteBearingRadians(center,
                                                                                                 m_pApp->GetGlobeCameraController().GetInterestBasis().GetForward());
        
        Eegeo::Space::EcefTangentBasis cameraInterestBasis;
        Eegeo::Camera::CameraHelpers::EcefTangentBasisFromPointAndHeading(center,
                                                                          Eegeo::Math::Rad2Deg(currentBearingRads),
                                                                          cameraInterestBasis);
        
        m_pApp->SetCameraView(cameraInterestBasis, altitude, 45.f);
    }
}


- (id<EGPrecacheOperation>)precacheMapDataInCoordinateBounds:(EGCoordinateBounds)bounds
{
    Eegeo::dv3 ne = Eegeo::Space::LatLong::FromDegrees(bounds.ne.latitude, bounds.ne.longitude).ToECEF();
    Eegeo::dv3 sw = Eegeo::Space::LatLong::FromDegrees(bounds.sw.latitude, bounds.sw.longitude).ToECEF();
    Eegeo::dv3 ecefCenter = (ne + sw) / 2.0;
    double boundingRadius = fmax((ecefCenter - ne).Length(), (ecefCenter - sw).Length());

    
    EGPrecacheOperationImplementation* pEGPrecacheOperation = [[[EGPrecacheOperationImplementation alloc]
                                                                initWithPrecacheService:m_pWorld->GetStreamingModule().GetPrecachingService()
                                                                scheduler:m_precacheOperationScheduler
                                                                center:ecefCenter
                                                                radius:boundingRadius
                                                                delegate:m_delegate] autorelease];
    
    m_precacheOperationScheduler.EnqueuePrecacheOperation(*pEGPrecacheOperation);
    return pEGPrecacheOperation;
}

- (void)setMapTheme:(EGMapTheme*)mapTheme
{
    Eegeo::Resources::CityThemes::ICityThemesService& cityThemesService = m_pWorld->GetCityThemesModule().GetCityThemesService();
    Eegeo::Resources::CityThemes::ICityThemesUpdater& cityThemesUpdater = m_pWorld->GetCityThemesModule().GetCityThemesUpdater();

    if(mapTheme.enableThemeByLocation)
    {
        // bit shonky: semantic meaning of themeName changes based on whether it is an explicitly
        // named theme, or a location-based name of a season. Underlying C++ API needs some love.
        cityThemesUpdater.SetEnabled(true);
        cityThemesUpdater.SetThemeMustContain([mapTheme.themeName UTF8String]);
        cityThemesService.RequestTransitionToState([mapTheme.themeStateName UTF8String], 1.0f);
    }
    else
    {
        Eegeo::Resources::CityThemes::ICityThemeRepository& cityThemesRepository = m_pWorld->GetCityThemesModule().GetCityThemesRepository();
        const Eegeo::Resources::CityThemes::CityThemeData* pTheme = cityThemesRepository.GetThemeDataByName([mapTheme.themeName UTF8String]);

        if(pTheme != NULL)
        {
            cityThemesUpdater.SetEnabled(false);
            cityThemesService.SetSpecificTheme(*pTheme);
            std::string state = [mapTheme.themeStateName UTF8String];
            cityThemesService.RequestTransitionToState(state, 1.0f);
        }
    }
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
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchRotate_Start:(const AppInterface::RotateData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchRotate_End:(const AppInterface::RotateData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPinch:(const AppInterface::PinchData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPinch_Start:(const AppInterface::PinchData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPinch_End:(const AppInterface::PinchData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPan:(const AppInterface::PanData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPan_Start:(const AppInterface::PanData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchPan_End:(const AppInterface::PanData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchTap:(const AppInterface::TapData&)data
{
    Eegeo::v2 screenTapPoint = Eegeo::v2(data.point.GetX(), data.point.GetY());
    m_pAnnotationController->HandleTap(screenTapPoint);
    
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchDoubleTap:(const AppInterface::TapData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchDown:(const AppInterface::TouchData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchMove:(const AppInterface::TouchData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

- (BOOL)Event_TouchUp:(const AppInterface::TouchData&)data
{
    bool eventConsumed = m_pCameraTransitioner->IsTransitioning();
    return eventConsumed;
}

@end
