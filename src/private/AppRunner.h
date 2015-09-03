// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#include "Graphics.h"
#include "AppHost.h"
#include "GlDisplayService.h"
#include "Types.h"

@class ViewController;

class AppRunner : Eegeo::NonCopyable
{
public:
	AppRunner(
	    const std::string& apiKey
    );
    
	~AppRunner();

	void Pause();
	void Resume();
    void Update(float deltaSeconds);
    void Draw(float deltaSeconds);
    
    bool TryBindDisplay(GLKView& view,
                        id<UIGestureRecognizerDelegate>& gestureRecognizer);
    void UnbindInputProvider();
    
    bool ShouldAutoRotateToInterfaceOrientation(UIInterfaceOrientation interfaceOrientation);

    void NotifyViewLayoutChanged(GLKView& view);
    
    bool IsAppHostAvailable() const;
    AppHost& GetAppHost() const;
private:
    std::string m_apiKey;

	GlDisplayService m_displayService;
	void ReleaseDisplay();

	AppHost* m_pAppHost;
	void CreateAppHost();

    bool ShouldUpdateAndDraw() const;
};

