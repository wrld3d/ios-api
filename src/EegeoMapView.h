// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <GLKit/GLKit.h>
#import "EegeoMapDelegate.h"

@interface EegeoMapView : GLKView<UIGestureRecognizerDelegate>

- (id)initWithFrame:(CGRect)frame;

@property(assign, nonatomic) id<EegeoMapDelegate> eegeoMapDelegate;

@end
