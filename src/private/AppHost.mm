// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include "App.h"
#include "AppHost.h"
#include "LatLongAltitude.h"
#include "EegeoWorld.h"
#include "RenderContext.h"
#include "AppInterface.h"
#include "EffectHandler.h"
#include "SearchServiceCredentials.h"
#include "GlobeCameraController.h"
#include "RenderCamera.h"
#include "CameraHelpers.h"
#include "PlatformConfig.h"
#include "iOSPlatformConfigBuilder.h"
#include "EegeoWorld.h"
#include "JpegLoader.h"
#include "iOSPlatformAbstractionModule.h"
#include "ScreenProperties.h"

using namespace Eegeo::iOS;

AppHost::AppHost(const std::string& apiKey,
                 const Eegeo::Rendering::ScreenProperties& screenProperties)
    :m_pJpegLoader(NULL)
	,m_piOSLocationService(NULL)
	,m_pWorld(NULL)
	,m_iOSInputBoxFactory()
	,m_iOSKeyboardInputFactory()
	,m_iOSAlertBoxFactory()
	,m_iOSNativeUIFactories(m_iOSAlertBoxFactory, m_iOSInputBoxFactory, m_iOSKeyboardInputFactory)
    ,m_piOSPlatformAbstractionModule(NULL)
	,m_pApp(NULL)
    ,m_pAppInputDelegate(NULL)
{
	m_piOSLocationService = new iOSLocationService();
	   
    m_pJpegLoader = new Eegeo::Helpers::Jpeg::JpegLoader();
    
    m_piOSPlatformAbstractionModule = new Eegeo::iOS::iOSPlatformAbstractionModule(*m_pJpegLoader, apiKey);

	Eegeo::EffectHandler::Initialise();

	const Eegeo::EnvironmentCharacterSet::Type environmentCharacterSet = Eegeo::EnvironmentCharacterSet::Latin;
    
	Eegeo::Config::PlatformConfig config = Eegeo::iOS::iOSPlatformConfigBuilder(App::GetDevice(), App::IsDeviceMultiCore(), App::GetMajorSystemVersion()).Build();
    
    config.OptionsConfig.StartMapModuleAutomatically = false;
    config.OptionsConfig.GenerateCollisionForAllResources = true;
    
	m_pWorld = new Eegeo::EegeoWorld(apiKey,
                                     *m_piOSPlatformAbstractionModule,
                                     *m_pJpegLoader,
                                     screenProperties,
                                     *m_piOSLocationService,
                                     m_iOSNativeUIFactories,
                                     environmentCharacterSet,
                                     config,
                                     NULL);
    
    m_pApp = new ExampleApp(m_pWorld, screenProperties);
    
    m_pAppLocationDelegate = new AppLocationDelegate(*m_piOSLocationService);
    
    Eegeo::TtyHandler::TtyEnabled = false;
}

AppHost::~AppHost()
{
    delete m_pAppLocationDelegate;
    m_pAppLocationDelegate = NULL;
    
	delete m_pAppInputDelegate;
	m_pAppInputDelegate = NULL;

	delete m_pApp;
	m_pApp = NULL;

	delete m_pWorld;
	m_pWorld = NULL;

	delete m_piOSLocationService;
	m_piOSLocationService = NULL;
    
    delete m_piOSPlatformAbstractionModule;
    m_piOSPlatformAbstractionModule = NULL;
    
    delete m_pJpegLoader;
    m_pJpegLoader = NULL;

	Eegeo::EffectHandler::Reset();
	Eegeo::EffectHandler::Shutdown();
}

void AppHost::UnbindInputProvider()
{
    Eegeo_DELETE m_pAppInputDelegate;
    m_pAppInputDelegate = NULL;
}

void AppHost::BindInputProvider(GLKView &view,
                                id<UIGestureRecognizerDelegate>& gestureRecognizer,
                                const Eegeo::Rendering::ScreenProperties& screenProperties)
{
    UnbindInputProvider();
    
    m_pAppInputDelegate = new AppInputDelegate(*m_pApp,
                                               view,
                                               gestureRecognizer,
                                               screenProperties.GetScreenWidth(),
                                               screenProperties.GetScreenHeight(),
                                               screenProperties.GetPixelScale());
}

void AppHost::BindApi(EegeoMapApiImplementation& api)
{
    m_pAppInputDelegate->BindApi(api);
}

void AppHost::UnbindApi()
{
    m_pAppInputDelegate->UnbindApi();
}

void AppHost::OnResume()
{
	m_pApp->OnResume();
}

void AppHost::OnPause()
{
	m_pApp->OnPause();
}

void AppHost::SetViewportOffset(float x, float y)
{
}

void AppHost::NotifyScreenPropertiesChanged(const Eegeo::Rendering::ScreenProperties& screenProperties)
{
    m_pApp->NotifyScreenPropertiesChanged(screenProperties);
}

void AppHost::Update(float dt)
{
    Eegeo::Modules::Map::MapModule& mapModule = m_pWorld->GetMapModule();
    if (!mapModule.IsRunning() && m_pAppLocationDelegate->HasReceivedPermissionResponse())
    {
        mapModule.Start();
    }
	m_pApp->Update(dt);
}

void AppHost::Draw(float dt)
{
	m_pApp->Draw(dt);
}


