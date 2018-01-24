#pragma once

#import "WRLDSearchProviderDelegate.h"

@class WRLDSearchResult;
@protocol WRLDSearchResultsArrivedDelegate;

@interface WRLDSearchResultSet : NSObject <WRLDSearchProviderDelegate>

- (WRLDSearchResult*)getResult: (NSInteger) index;

- (NSInteger)getVisibleResultCount;

- (NSInteger)getResultCount;

-(void) setExpandedState :(NSInteger) state;

-(bool) hasMoreToShow;
-(bool) hasReceivedResults;

typedef NS_ENUM(NSInteger, ExpandedStateType) {
    Hidden,
    Collapsed,
    Expanded
};

-(ExpandedStateType) getExpandedState;

@end
