#pragma once

#import <UIKit/UIKit.h>

namespace Eegeo {
    class ITouchController;
}


@interface WRLDGestureDelegate : NSObject<UIGestureRecognizerDelegate>


-(instancetype) initWith :(Eegeo::ITouchController*)pTouchController
                         :(float)width
                         :(float)height
                         :(float)pixelScale;

-(void) bind:(UIView*)pView;

-(void) unbind;


@end
