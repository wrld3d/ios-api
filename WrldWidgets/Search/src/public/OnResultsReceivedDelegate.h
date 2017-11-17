#pragma once

@class SearchResult;

@protocol OnResultsReceivedDelegate <NSObject>

-(void) addResults: (NSMutableArray<SearchResult*>*) searchResults;
-(void) clearResults;

@end

