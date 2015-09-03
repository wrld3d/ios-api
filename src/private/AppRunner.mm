// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include "AppRunner.h"
#include "Graphics.h"
#include "App.h"

AppRunner::AppRunner
(
 const std::string& apiKey
)
	: m_apiKey(apiKey)
	, m_pAppHost(NULL)
{
	ReleaseDisplay();
	CreateAppHost();
}

AppRunner::~AppRunner()
{
	m_displayService.ReleaseDisplay();

	if(m_pAppHost != NULL)
	{
		Eegeo_DELETE(m_pAppHost);
	}
}

bool AppRunner::IsAppHostAvailable() const
{
    return m_pAppHost != NULL;
}

AppHost& AppRunner::GetAppHost() const
{
    Eegeo_ASSERT(IsAppHostAvailable());
    return *m_pAppHost;
}

void AppRunner::CreateAppHost()
{
	if(m_pAppHost == NULL && m_displayService.IsDisplayAvailable())
    {
        const Eegeo::Rendering::ScreenProperties& screenProperties =
        Eegeo::Rendering::ScreenProperties::Make(m_displayService.GetDisplayWidth(),
                                                 m_displayService.GetDisplayHeight(),
                                                 m_displayService.GetPixelScale(),
                                                 m_displayService.GetDisplayDpi());
        
        
		m_pAppHost = Eegeo_NEW(AppHost)(m_apiKey, screenProperties);
	}
}

void AppRunner::Pause()
{
	if(m_pAppHost != NULL)
	{
		m_pAppHost->OnPause();
	}
}

void AppRunner::Resume()
{
	if(m_pAppHost != NULL)
	{
		m_pAppHost->OnResume();
	}
}

void AppRunner::ReleaseDisplay()
{
	if(m_displayService.IsDisplayAvailable())
	{
		m_displayService.ReleaseDisplay();
	}
}

void AppRunner::UnbindInputProvider()
{
    if(m_pAppHost != NULL)
    {
        m_pAppHost->UnbindInputProvider();
    }
}

bool AppRunner::TryBindDisplay(GLKView& view,
                               id<UIGestureRecognizerDelegate>& gestureRecognizer)
{
	if(m_displayService.TryBindDisplay(view))
    {
        CreateAppHost();
        
		if(m_pAppHost != NULL)
		{
            m_pAppHost->SetViewportOffset(0, 0);
            
            const Eegeo::Rendering::ScreenProperties& screenProperties =
            Eegeo::Rendering::ScreenProperties::Make(
                                                     m_displayService.GetDisplayWidth(),
                                                     m_displayService.GetDisplayHeight(),
                                                     m_displayService.GetPixelScale(),
                                                     m_displayService.GetDisplayDpi());
            
            m_pAppHost->BindInputProvider(view, gestureRecognizer, screenProperties);
        }

		return true;
	}

	return false;
}

bool AppRunner::ShouldUpdateAndDraw() const
{
    return m_pAppHost != NULL && m_displayService.IsDisplayAvailable();
}

void AppRunner::Update(float deltaSeconds)
{
	if(ShouldUpdateAndDraw())
	{
		m_pAppHost->Update(deltaSeconds);
	}
}

void AppRunner::Draw(float deltaSeconds)
{
    if(ShouldUpdateAndDraw())
    {
        Eegeo::Helpers::GLHelpers::ClearBuffers();

        m_pAppHost->Draw(deltaSeconds);
    }
}

void AppRunner::NotifyViewLayoutChanged(GLKView& view)
{
    if (m_displayService.IsDisplayAvailable())
    {
        m_displayService.UpdateDisplayDimensions(view);
        
        const Eegeo::Rendering::ScreenProperties& screenProperties =
            Eegeo::Rendering::ScreenProperties::Make(
                                                     m_displayService.GetDisplayWidth(),
                                                     m_displayService.GetDisplayHeight(),
                                                     m_displayService.GetPixelScale(),
                                                     m_displayService.GetDisplayDpi());
        
        m_pAppHost->NotifyScreenPropertiesChanged(screenProperties);
    }
}

bool AppRunner::ShouldAutoRotateToInterfaceOrientation(UIInterfaceOrientation interfaceOrientation)
{
    // if return true , OS intersects interfaceOrientation with supported orientations for app (specified in info.plist), only
    // rotates if mode is allowed 
    return true;
}
