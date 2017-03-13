// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include "ExampleApp.h"
#include "GlobeCameraTouchController.h"
#include "RenderCamera.h"
#include "GlobeCameraController.h"
#include "GlobeCameraInterestPointProvider.h"
#include "CameraHelpers.h"
#include "LatLongAltitude.h"
#include "ScreenProperties.h"
#include "InteriorsCameraController.h"
#include "NavigationService.h"
#include "GpsGlobeCameraControllerFactory.h"
#include "InteriorsCameraControllerFactory.h"
#include "EegeoMapApiFactory.h"
#include "EegeoSpacesApi.h"
#include "EegeoCameraApi.h"

// Modules
#include "MapModule.h"
#include "TerrainModelModule.h"
#include "CameraFrustumStreamingVolume.h"

namespace
{
    Eegeo::Rendering::LoadingScreen* CreateLoadingScreen(const Eegeo::Rendering::ScreenProperties& screenProperties,
                                                         const Eegeo::Modules::Core::RenderingModule& renderingModule,
                                                         const Eegeo::Modules::IPlatformAbstractionModule& platformAbstractionModule)
    {
        Eegeo::Rendering::LoadingScreenConfig loadingScreenConfig;
        loadingScreenConfig.loadingBarBackgroundColor = Eegeo::v4(0.45f, 0.7f, 1.0f, 1.0f);
        loadingScreenConfig.fadeOutDurationSeconds = 1.5f;
        loadingScreenConfig.screenWidth = screenProperties.GetScreenWidth();
        loadingScreenConfig.screenHeight = screenProperties.GetScreenHeight();
        loadingScreenConfig.backgroundColor = Eegeo::v4(132.f/255.f, 203.f/255.f, 235.f/255.f, 1.f);
        loadingScreenConfig.loadingBarOffset = Eegeo::v2(0.5f, 0.1f);
        loadingScreenConfig.layout = Eegeo::Rendering::LoadingScreenLayout::Centred;
        
        Eegeo::Rendering::LoadingScreen* loadingScreen = Eegeo::Rendering::LoadingScreen::Create(
            "SplashScreen-1024x768.png",
            loadingScreenConfig,
            renderingModule.GetShaderIdGenerator(),
            renderingModule.GetMaterialIdGenerator(),
            renderingModule.GetGlBufferPool(),
            renderingModule.GetVertexLayoutPool(),
            renderingModule.GetVertexBindingPool(),
            platformAbstractionModule.GetTextureFileLoader());
            
        return loadingScreen;
    }
}


void ExampleApp::CreateInteriorsCameraController()
{
    Eegeo::Modules::Map::MapModule& mapModule = World().GetMapModule();
    Eegeo::Modules::Map::Layers::InteriorsPresentationModule& interiorsPresentationModule = mapModule.GetInteriorsPresentationModule();
    
    Eegeo::Camera::GlobeCamera::GlobeCameraControllerFactory globeCameraControllerFactory(
            mapModule.GetTerrainModelModule().GetTerrainHeightProvider(),
            mapModule.GetEnvironmentFlatteningService(),
            mapModule.GetResourceCeilingProvider());
    
    const Eegeo::Resources::Interiors::InteriorsCameraConfiguration& interiorsCameraConfig = Eegeo::Resources::Interiors::InteriorsCameraController::CreateDefaultConfig();
    const Eegeo::Camera::GlobeCamera::GlobeCameraControllerConfiguration& globeCameraConfig = Eegeo::Resources::Interiors::InteriorsCameraControllerFactory::DefaultGlobeCameraControllerConfiguration();
    const Eegeo::Camera::GlobeCamera::GlobeCameraTouchControllerConfiguration& globeCameraTouchConfig = Eegeo::Resources::Interiors::InteriorsCameraControllerFactory::DefaultGlobeCameraTouchControllerConfiguration();
    
    const bool interiorsAffectedByFlattening = false;
    
    Eegeo::Resources::Interiors::InteriorsCameraControllerFactory interiorsCameraControllerFactory(                                                                            interiorsCameraConfig,
        globeCameraConfig,
        globeCameraTouchConfig,
        globeCameraControllerFactory,
        m_screenPropertiesProvider.GetScreenProperties(),
        interiorsPresentationModule.GetInteriorInteractionModel(),
        interiorsPresentationModule.GetInteriorViewModel(),
        mapModule.GetEnvironmentFlatteningService(),
        interiorsAffectedByFlattening);
    
    m_pInteriorTouchController = interiorsCameraControllerFactory.CreateTouchController();
    m_pInteriorGlobeCameraController = interiorsCameraControllerFactory.CreateInteriorGlobeCameraController(*m_pInteriorTouchController);
    m_pInteriorsCameraController = interiorsCameraControllerFactory.CreateInteriorsCameraController(*m_pInteriorTouchController, *m_pInteriorGlobeCameraController);
}

void ExampleApp::DeleteInteriorsCameraController()
{
    Eegeo_DELETE m_pInteriorsCameraController;
    Eegeo_DELETE m_pInteriorGlobeCameraController;
    Eegeo_DELETE m_pInteriorTouchController;
}

void ExampleApp::CreateGpsGlobeCameraController()
{
    Eegeo::Modules::Map::MapModule& mapModule = World().GetMapModule();
    Eegeo::Resources::Terrain::Heights::TerrainHeightProvider& terrainHeightProvider = World().GetTerrainModelModule().GetTerrainHeightProvider();
    
    m_pNavigationService = Eegeo_NEW(Eegeo::Location::NavigationService)(&World().GetLocationService(), &terrainHeightProvider);
    
    Eegeo::Camera::GlobeCamera::GpsGlobeCameraControllerFactory gpsGlobeCameraControllerFactory(terrainHeightProvider,
                                                                                                mapModule.GetEnvironmentFlatteningService(),
                                                                                                mapModule.GetResourceCeilingProvider(),
                                                                                                *m_pNavigationService);
    
    const bool useLowSpecSettings = false;

    m_pGpsGlobeCameraController = gpsGlobeCameraControllerFactory.Create(
        useLowSpecSettings,
        m_screenPropertiesProvider.GetScreenProperties());
    
    m_pCameraTouchController = &m_pGpsGlobeCameraController->GetTouchController();
    
}

void ExampleApp::DeleteGpsGlobeCameraController()
{
    Eegeo_DELETE m_pGpsGlobeCameraController;
    Eegeo_DELETE m_pNavigationService;
}

ExampleApp::ExampleApp(Eegeo::EegeoWorld* pWorld,
                       const Eegeo::Rendering::ScreenProperties& screenProperties)
	: m_pCameraTouchController(NULL)
	, m_pWorld(pWorld)
    , m_pLoadingScreen(NULL)
    , m_screenPropertiesProvider(screenProperties)
{
    Eegeo::EegeoWorld& eegeoWorld = *m_pWorld;
	m_pLoadingScreen = CreateLoadingScreen(screenProperties, eegeoWorld.GetRenderingModule(), eegeoWorld.GetPlatformAbstractionModule());
    
    // :TODO: consider whether camera creation should be moved to the API implementation & ExampleApp should depend on the API
    CreateGpsGlobeCameraController();
    CreateInteriorsCameraController();
    
    const int mapId = 0;
    m_pDebugCommandBuffer = new Eegeo::Debug::Commands::CommandBuffer();
    m_pMapApi = Eegeo::Api::EegeoMapApiFactory::CreateMapApi(mapId,
                                                             eegeoWorld,
                                                             m_pGpsGlobeCameraController->GetRenderCamera(),
                                                             *m_pGpsGlobeCameraController,
                                                             *m_pInteriorsCameraController,
                                                             *m_pDebugCommandBuffer);
    
    m_pMapApi->NotifyInitialized();
    
    const double interestPointLatitudeDegrees = 37.793436;
    const double interestPointLongitudeDegrees = -122.398654;
    const double interestPointAltitudeMeters = 2.7;
    const double cameraControllerOrientationDegrees = 0.0;
    const double cameraControllerDistanceFromInterestPointMeters = 1781.0;
    const double tiltDegrees = 45.0;
    const double transitionDuration = 0.0;
    
    const bool animate = false;
    const bool modifyPosition = true;
    const bool modifyDistance = true;
    const bool modifyHeading = true;
    const bool modifyTilt = true;
    const bool hasTransitionDuration = false;
    const bool jumpIfFarAway = true;
    const bool allowInterruption = false;
    
    m_pMapApi->GetCameraApi().SetView(animate, interestPointLatitudeDegrees, interestPointLongitudeDegrees, interestPointAltitudeMeters, modifyPosition, cameraControllerDistanceFromInterestPointMeters, modifyDistance, cameraControllerOrientationDegrees, modifyHeading, tiltDegrees, modifyTilt, transitionDuration, hasTransitionDuration, jumpIfFarAway, allowInterruption);
}

ExampleApp::~ExampleApp()
{
    DeleteInteriorsCameraController();
    DeleteGpsGlobeCameraController();

    delete m_pDebugCommandBuffer;
    delete m_pLoadingScreen;
}

void ExampleApp::OnPause()
{
	Eegeo::EegeoWorld& eegeoWorld = World();
	eegeoWorld.OnPause();
}

void ExampleApp::OnResume()
{
	Eegeo::EegeoWorld& eegeoWorld = World();
	eegeoWorld.OnResume();
}

void ExampleApp::Update (float dt)
{
	Eegeo::EegeoWorld& eegeoWorld = World();
    

    m_pGpsGlobeCameraController->Update(dt);

	eegeoWorld.EarlyUpdate(dt);
    
    Eegeo::Camera::GlobeCamera::GlobeCameraController& cameraController = GetGlobeCameraController();
    
    Eegeo::Camera::CameraState cameraState(cameraController.GetCameraState());
    Eegeo::Streaming::IStreamingVolume& streamingVolume(World().GetMapModule().GetStreamingVolume());
    
    Eegeo::EegeoUpdateParameters updateParameters(dt,
                                                  cameraState.LocationEcef(),
                                                  cameraState.InterestPointEcef(),
                                                  cameraState.ViewMatrix(),
                                                  cameraState.ProjectionMatrix(),
                                                  streamingVolume,
                                                  m_screenPropertiesProvider.GetScreenProperties());
    
	eegeoWorld.Update(updateParameters);
    
    m_pMapApi->OnUpdate(dt);
    
    UpdateLoadingScreen(dt);
}

void ExampleApp::Draw (float dt)
{
    Eegeo::EegeoWorld& eegeoWorld = World();
    Eegeo::Camera::GlobeCamera::GlobeCameraController& cameraController = GetGlobeCameraController();
    Eegeo::Camera::CameraState cameraState(cameraController.GetCameraState());
    
    Eegeo::EegeoDrawParameters drawParameters(cameraState.LocationEcef(),
                                              cameraState.InterestPointEcef(),
                                              cameraState.ViewMatrix(),
                                              cameraState.ProjectionMatrix(),
                                              m_screenPropertiesProvider.GetScreenProperties());
    
    eegeoWorld.Draw(drawParameters);
    
    if (m_pLoadingScreen != NULL)
    {
        //m_pLoadingScreen->Draw();
    }
    
    m_pMapApi->GetSpacesApi().UpdateRenderCamera(cameraController.GetRenderCamera());
    m_pMapApi->OnDraw(dt);
}

void ExampleApp::NotifyScreenPropertiesChanged(const Eegeo::Rendering::ScreenProperties& screenProperties)
{
    m_screenPropertiesProvider.NotifyScreenPropertiesChanged(screenProperties);
    GetGlobeCameraController().UpdateScreenProperties(screenProperties);
    
    if (m_pLoadingScreen != NULL)
    {
        m_pLoadingScreen->NotifyScreenDimensionsChanged(screenProperties.GetScreenWidth(), screenProperties.GetScreenHeight());
    }
}

void ExampleApp::SetCameraView(const Eegeo::Space::EcefTangentBasis& cameraInterestBasis, float distanceToInterest)
{
    Eegeo_ASSERT(!World().Initialising());
    GetGlobeCameraController().SetView(cameraInterestBasis, distanceToInterest);
}

void ExampleApp::SetCameraView(const Eegeo::Space::EcefTangentBasis& cameraInterestBasis, float distanceToInterest, float tiltAngleDegrees)
{
    SetCameraView(cameraInterestBasis, distanceToInterest);
    GetGlobeCameraController().ApplyTilt(tiltAngleDegrees);
}

void ExampleApp::UpdateLoadingScreen(float dt)
{
    if (m_pLoadingScreen == NULL)
    {
        return;
    }
    
    Eegeo::EegeoWorld& eegeoWorld = World();
    
    if (!eegeoWorld.Initialising() && !m_pLoadingScreen->IsDismissed())
    {
        m_pLoadingScreen->Dismiss();
    }
    
    m_pLoadingScreen->SetProgress(eegeoWorld.GetInitialisationProgress());
    m_pLoadingScreen->Update(dt);
    
    if (!m_pLoadingScreen->IsVisible())
    {
        Eegeo_DELETE m_pLoadingScreen;
        m_pLoadingScreen = NULL;
    }
}

void ExampleApp::Event_TouchRotate(const AppInterface::RotateData& data)
{
	if(World().Initialising())
	{
		return;
	}

	m_pCameraTouchController->Event_TouchRotate(data);
}

void ExampleApp::Event_TouchRotate_Start(const AppInterface::RotateData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchRotate_Start(data);
}

void ExampleApp::Event_TouchRotate_End(const AppInterface::RotateData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchRotate_End(data);
}

void ExampleApp::Event_TouchPinch(const AppInterface::PinchData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchPinch(data);
}

void ExampleApp::Event_TouchPinch_Start(const AppInterface::PinchData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
    m_pCameraTouchController->Event_TouchPinch_Start(data);
}

void ExampleApp::Event_TouchPinch_End(const AppInterface::PinchData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchPinch_End(data);
}

void ExampleApp::Event_TouchPan(const AppInterface::PanData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchPan(data);
}

void ExampleApp::Event_TouchPan_Start(const AppInterface::PanData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchPan_Start(data);
}

void ExampleApp::Event_TouchPan_End(const AppInterface::PanData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchPan_End(data);
}

void ExampleApp::Event_TouchTap(const AppInterface::TapData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchTap(data);
}

void ExampleApp::Event_TouchDoubleTap(const AppInterface::TapData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchDoubleTap(data);
}

void ExampleApp::Event_TouchDown(const AppInterface::TouchData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchDown(data);
}

void ExampleApp::Event_TouchMove(const AppInterface::TouchData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchMove(data);
}

void ExampleApp::Event_TouchUp(const AppInterface::TouchData& data)
{
    if(World().Initialising())
	{
		return;
	}
    
	m_pCameraTouchController->Event_TouchUp(data);
}

