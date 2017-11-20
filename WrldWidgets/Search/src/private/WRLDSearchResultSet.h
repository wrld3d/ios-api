#pragma once

#import "WRLDSearchProviderDelegate.h"
#import "WRLDSearchModuleDelegate.h"

@class WRLDSearchResult;

@interface WRLDSearchResultSet : NSObject <WRLDSearchProviderDelegate>

- (NSMutableArray<WRLDSearchResult*>*)getAllResults;

- (WRLDSearchResult*)getResult: (NSInteger) index;
- (WRLDSearchResult*)getSuggestion: (NSInteger) index;

- (NSInteger)getResultCount;
- (NSInteger)getSuggestionCount;

- (void) setUpdateDelegate:(id<WRLDSearchModuleDelegate>)delegate;

@end
