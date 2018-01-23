#pragma once

#import "WRLDSearchProviderDelegate.h"

@class WRLDSearchResult;
@protocol WRLDSearchResultsArrivedDelegate;

@interface WRLDSearchResultSet : NSObject <WRLDSearchProviderDelegate>

- (NSMutableArray<WRLDSearchResult*>*)getAllResults;

- (WRLDSearchResult*)getResult: (NSInteger) index;

- (NSInteger)getVisibleResultCount;

- (NSInteger)getResultCount;

- (void) updateDelegate :(id<WRLDSearchResultsArrivedDelegate>) delegate;

-(void) setExpandedState :(NSInteger) state;

-(bool) hasMoreToShow;

typedef NS_ENUM(NSInteger, ExpandedStateType) {
    Hidden,
    Collapsed,
    Expanded
};

-(ExpandedStateType) getExpandedState;

@end
