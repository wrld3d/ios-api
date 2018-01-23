#pragma once

#import "WRLDSearchProviderDelegate.h"

@class WRLDSearchResult;
@protocol WRLDSearchResultsArrivedDelegate;

@interface WRLDSearchResultSet : NSObject <WRLDSearchProviderDelegate>

- (NSMutableArray<WRLDSearchResult*>*)getAllResults;

- (WRLDSearchResult*)getResult: (NSInteger) index;

- (NSInteger)getResultCount;

- (void) updateDelegate :(id<WRLDSearchResultsArrivedDelegate>) delegate;

@end
