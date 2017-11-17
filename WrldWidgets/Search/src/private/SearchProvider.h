#pragma once

#import <Foundation/Foundation.h>
#import "OnResultsReceivedDelegate.h"

@class SearchResultViewFactory;


@protocol SearchProvider <NSObject>

@property (nonatomic, readonly, copy) NSString *title;

- (void)getSearchResults: (NSString*) query;

- (void) addOnResultsReceivedDelegate: (id<OnResultsReceivedDelegate>) resultsReceivedDelegate;

- (void) setResultViewFactory: (SearchResultViewFactory*) viewFactory;

- (SearchResultViewFactory*) getResultViewFactory;

- (void) onSelectedResult: (SearchResult*) searchResult;

@end
