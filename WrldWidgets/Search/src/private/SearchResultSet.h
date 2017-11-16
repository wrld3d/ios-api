#pragma once

#import "SearchResult.h"

@interface SearchResultSet : NSObject

//- (NSMutableArray<SearchResult*>*)sortOn: (NSString*)propertyKey;

- (NSMutableArray<SearchResult*>*)getAllResults;

//- (SearchResult*)getResult: (NSInteger) index;

//- (NSInteger)getResultCount;

- (void)addResult: (SearchResult*) searchResult;

//- (void)removeResult: (SearchResult*) searchResult;

//- (void)removeResultByIndex: (NSInteger) index;

//- (void)clear;

@end
