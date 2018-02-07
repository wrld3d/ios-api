#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchWidgetResultsReadyDelegate;

@class WRLDSearchWidgetSearchProviderReference : NSObject
-(void) addSearchCompletedDelegate(id<WRLDSearchWidgetResultsReadyDelegate>) delegate;
@end
