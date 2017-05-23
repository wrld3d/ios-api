#pragma once

#import <UIKit/UIKit.h>

namespace Eegeo {
    class ITouchController;
}

@class WRLDMapView;

@interface WRLDGestureDelegate : NSObject<UIGestureRecognizerDelegate>


-(instancetype) initWith :(Eegeo::ITouchController*)pTouchController
                         :(float)width
                         :(float)height
                         :(float)pixelScale;

-(void) bind:(WRLDMapView*)pView;

-(void) unbind;


@end
