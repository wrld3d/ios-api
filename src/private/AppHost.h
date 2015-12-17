// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include <UIKit/UIKit.h>
#include <GLKit/GLKit.h>
#include "Types.h"
#include "Graphics.h"
#include "IJpegLoader.h"
#include "GlobeCameraInterestPointProvider.h"
#include "iOSInputBoxFactory.h"
#include "iOSKeyboardInputFactory.h"
#include "iOSAlertBoxFactory.h"
#include "NativeUIFactories.h"
#include "TouchEventWrapper.h"
#include "AppInputDelegate.h"
#include "AppLocationDelegate.h"
#include "Modules.h"
#include <vector>

#include "ExampleApp.h"
#include "EegeoMapApiImplementation.h"

@class ViewController;
class AppInputDelegate;
class AppLocationDelegate;

class AppHost : protected Eegeo::NonCopyable
{
public:
    AppHost(const std::string& apiKey,
            const Eegeo::Rendering::ScreenProperties& screenProperties);
    
    ~AppHost();
    
    void BindInputProvider(GLKView& view,
                           id<UIGestureRecognizerDelegate>& gestureRecognizer,
                           const Eegeo::Rendering::ScreenProperties& screenProperties);
    void UnbindInputProvider();

	void Update(float dt);
	void Draw(float dt);

	void OnPause();
	void OnResume();
    
	void SetViewportOffset(float x, float y);
    
    void NotifyScreenPropertiesChanged(const Eegeo::Rendering::ScreenProperties& screenProperties);
    
    ExampleApp& App() const { return *m_pApp; }
    Eegeo::EegeoWorld& World() const { return *m_pWorld; }
    
    void BindApi(EegeoMapApiImplementation& api);
    void UnbindApi();
    
private:
    
    Eegeo::Helpers::Jpeg::IJpegLoader* m_pJpegLoader;
	Eegeo::iOS::iOSLocationService* m_piOSLocationService;
	Eegeo::EegeoWorld* m_pWorld;
	AppInputDelegate* m_pAppInputDelegate;
    AppLocationDelegate* m_pAppLocationDelegate;

	Eegeo::UI::NativeInput::iOS::iOSInputBoxFactory m_iOSInputBoxFactory;
	Eegeo::UI::NativeInput::iOS::iOSKeyboardInputFactory m_iOSKeyboardInputFactory;
	Eegeo::UI::NativeAlerts::iOS::iOSAlertBoxFactory m_iOSAlertBoxFactory;
	Eegeo::UI::NativeUIFactories m_iOSNativeUIFactories;
    Eegeo::iOS::iOSPlatformAbstractionModule* m_piOSPlatformAbstractionModule;

	ExampleApp* m_pApp;
};

