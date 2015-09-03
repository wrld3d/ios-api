// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>
#import "EGMapApi.h"
#import "EGApi.h"
#include "EegeoWorld.h"
#include "ExampleApp.h"
#include "AppInterface.h"

@interface EegeoMapApiImplementation : NSObject<EGMapApi>

- (id)initWithWorld:(Eegeo::EegeoWorld&)world
                app:(ExampleApp&)app
           delegate:(id<EGMapDelegate>)delegate
               view:(UIView*)view;

- (void)teardown;

- (void)update:(float)dt;

- (void)updateScreenProperties:(const Eegeo::Rendering::ScreenProperties&)screenProperties;

- (BOOL)Event_TouchRotate:(const AppInterface::RotateData&)data;
- (BOOL)Event_TouchRotate_Start:(const AppInterface::RotateData&)data;
- (BOOL)Event_TouchRotate_End:(const AppInterface::RotateData&)data;

- (BOOL)Event_TouchPinch:(const AppInterface::PinchData&)data;
- (BOOL)Event_TouchPinch_Start:(const AppInterface::PinchData&)data;
- (BOOL)Event_TouchPinch_End:(const AppInterface::PinchData&)data;

- (BOOL)Event_TouchPan:(const AppInterface::PanData&)data;
- (BOOL)Event_TouchPan_Start:(const AppInterface::PanData&)data;
- (BOOL)Event_TouchPan_End:(const AppInterface::PanData&)data;

- (BOOL)Event_TouchTap:(const AppInterface::TapData&)data;
- (BOOL)Event_TouchDoubleTap:(const AppInterface::TapData&)data;

- (BOOL)Event_TouchDown:(const AppInterface::TouchData&)data;
- (BOOL)Event_TouchMove:(const AppInterface::TouchData&)data;
- (BOOL)Event_TouchUp:(const AppInterface::TouchData&)data;

@end
