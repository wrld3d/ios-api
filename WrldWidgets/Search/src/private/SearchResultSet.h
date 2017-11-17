#pragma once

#import "OnResultsReceivedDelegate.h"
#import "OnSuggestionsReceivedDelegate.h"

@protocol OnResultsModelUpdateDelegate;

@ class SearchResult;

@interface SearchResultSet : NSObject <OnResultsReceivedDelegate, OnSuggestionsReceivedDelegate>

//- (NSMutableArray<SearchResult*>*)sortOn: (NSString*)propertyKey;

- (NSMutableArray<SearchResult*>*)getAllResults;

- (SearchResult*)getResult: (NSInteger) index;
- (SearchResult*)getSuggestion: (NSInteger) index;

- (NSInteger)getResultCount;
- (NSInteger)getSuggestionCount;

- (void)addUpdateDelegate: (id<OnResultsModelUpdateDelegate>) delegate;

@end
