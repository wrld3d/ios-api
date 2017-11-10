// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>
#import "SearchProvider.h"

@interface WRLDSearchModule : UIView

- (instancetype) initWithFrame:(CGRect) frame;
- (void) addSearchProvider:(SearchProvider) searchProvider;

@end
