#pragma once

#import <UIKit/UIKit.h>
#import "WRLDQueryFulfiller.h"

@protocol WRLDSearchResultsReadyDelegate;

@interface WRLDSuggestionProviderReference : NSObject<WRLDQueryFulfiller>
-(void) addSuggestionsCompletedDelegate: (id<WRLDSearchResultsReadyDelegate>) delegate;
@end
