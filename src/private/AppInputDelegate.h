// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#include "Types.h"
#include "ExampleApp.h"
#import "EegeoMapApiImplementation.h"
#import <UIKit/UIKit.h>

@class ViewController;

class AppInputDelegate;

@interface AppInputDelegateGestureListener : NSObject

-(void) bindToViewController:(UIView*)pView :(id<UIGestureRecognizerDelegate>*)pGestureRecognizer :(AppInputDelegate*)pAppInputDelegate :(float)width :(float)height :(float)pixelScale;

@end

class AppInputDelegate : protected Eegeo::NonCopyable
{
public:
	AppInputDelegate(
                     ExampleApp& exampleApp,
                     UIView& view,
                     id<UIGestureRecognizerDelegate>& gestureRecognizer,
                     float width,
                     float height,
                     float pixelScale
                     );
	~AppInputDelegate();
    
    bool HasApi() const;
    void BindApi(EegeoMapApiImplementation& api);
    void UnbindApi();
    
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

private:
	ExampleApp& m_exampleApp;
    EegeoMapApiImplementation* m_pBoundApi;
    AppInputDelegateGestureListener* m_pAppInputDelegateGestureListener;
};

