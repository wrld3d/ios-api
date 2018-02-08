#pragma once

#import <UIKit/UIKit.h>
#import "WRLDQueryFulfiller.h"

@protocol WRLDSearchResultsReadyDelegate;

@interface WRLDSearchProviderReference : NSObject<WRLDQueryFulfiller>
-(void) addSearchCompletedDelegate: (id<WRLDSearchResultsReadyDelegate>) delegate;
@end
