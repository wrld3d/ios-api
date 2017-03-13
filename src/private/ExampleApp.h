// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#include "GlobeCamera.h"
#include "EegeoWorld.h"
#include "ScreenProperties.h"
#include "DefaultCameraControllerFactory.h"
#include "AppInterface.h"
#include "GlobeCameraController.h"
#include "EegeoMapApi.h"
#include "Location.h"
#include "GpsGlobeCameraController.h"
#include "Commands.h"

class ExampleApp : private Eegeo::NonCopyable
{
private:
    Eegeo::Camera::GlobeCamera::GpsGlobeCameraController* m_pGpsGlobeCameraController;
    Eegeo::Location::NavigationService* m_pNavigationService;
    
    Eegeo::Camera::GlobeCamera::GlobeCameraTouchController* m_pInteriorTouchController;
    Eegeo::Camera::GlobeCamera::GlobeCameraController* m_pInteriorGlobeCameraController;
    Eegeo::Resources::Interiors::InteriorsCameraController* m_pInteriorsCameraController;
    
    Eegeo::Debug::Commands::CommandBuffer* m_pDebugCommandBuffer;
    
	Eegeo::ITouchController* m_pCameraTouchController;
	Eegeo::EegeoWorld* m_pWorld;
    Eegeo::Rendering::LoadingScreen* m_pLoadingScreen;
    Examples::ScreenPropertiesProvider m_screenPropertiesProvider;
    Eegeo::Api::EegeoMapApi* m_pMapApi;

	Eegeo::EegeoWorld& World()
	{
		return * m_pWorld;
	}
    
    void UpdateLoadingScreen(float dt);
    void CreateInteriorsCameraController();
    void DeleteInteriorsCameraController();
    void CreateGpsGlobeCameraController();
    void DeleteGpsGlobeCameraController();

public:
	ExampleApp(Eegeo::EegeoWorld* pWorld,
               const Eegeo::Rendering::ScreenProperties& screenProperties);

	~ExampleApp();

	void OnPause();

	void OnResume();

	void Update (float dt);

	void Draw (float dt);
    
    void NotifyScreenPropertiesChanged(const Eegeo::Rendering::ScreenProperties& screenProperties);
    
    Eegeo::Camera::GlobeCamera::GlobeCameraController& GetGlobeCameraController() const { return m_pGpsGlobeCameraController->GetGlobeCameraController(); }
    
    void SetCameraView(const Eegeo::Space::EcefTangentBasis& cameraInterestBasis, float distanceToInterest);
    
    void SetCameraView(const Eegeo::Space::EcefTangentBasis& cameraInterestBasis, float distanceToInterest, float tiltAngleDegrees);
    
	Eegeo::ITouchController& GetTouchController()
	{
		return *m_pCameraTouchController;
	}
    
    const Examples::IScreenPropertiesProvider& GetScreenPropertiesProvider() const { return m_screenPropertiesProvider; }
    
    Eegeo::Api::EegeoMapApi& GetApi() { return *m_pMapApi; }

	void Event_TouchRotate 			(const AppInterface::RotateData& data);
	void Event_TouchRotate_Start	(const AppInterface::RotateData& data);
	void Event_TouchRotate_End 		(const AppInterface::RotateData& data);

	void Event_TouchPinch 			(const AppInterface::PinchData& data);
	void Event_TouchPinch_Start 	(const AppInterface::PinchData& data);
	void Event_TouchPinch_End 		(const AppInterface::PinchData& data);

	void Event_TouchPan				(const AppInterface::PanData& data);
	void Event_TouchPan_Start		(const AppInterface::PanData& data);
	void Event_TouchPan_End 		(const AppInterface::PanData& data);

	void Event_TouchTap 			(const AppInterface::TapData& data);
	void Event_TouchDoubleTap		(const AppInterface::TapData& data);

	void Event_TouchDown 			(const AppInterface::TouchData& data);
	void Event_TouchMove 			(const AppInterface::TouchData& data);
	void Event_TouchUp 				(const AppInterface::TouchData& data);
};
