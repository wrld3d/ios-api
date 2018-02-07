#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchWidgetResultsReadyDelegate;

@class WRLDSearchWidgetSuggestionProviderReference : NSObject
-(void) addSuggestionsCompletedDelegate(id<WRLDSearchWidgetResultsReadyDelegate>) delegate;
@end
