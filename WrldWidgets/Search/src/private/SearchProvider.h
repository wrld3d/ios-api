#pragma once

#import <Foundation/Foundation.h>
#import "OnResultsRecievedCallback.h"

@class SearchResultViewFactory;


@protocol SearchProvider <NSObject>

@property (nonatomic, readonly, copy) NSString *title;

- (void)getSearchResults: (NSString*) query;

- (void) addOnResultsRecievedCallback: (id<OnResultsRecievedCallback>) resultsReceivedCallback;

- (void) setResultViewFactory: (SearchResultViewFactory*) viewFactory;

- (SearchResultViewFactory*) getResultViewFactory;

@end
