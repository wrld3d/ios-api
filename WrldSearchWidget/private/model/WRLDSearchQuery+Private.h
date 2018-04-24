#pragma once

#include "WRLDSearchQuery.h"
#include "WRLDSearchTypes.h"

@class WRLDSearchQueryObserver;
@class WRLDSearchRequest;
@protocol WRLDSearchRequestFulfillerHandle;

@interface WRLDSearchQuery (Private)

- (instancetype) initWithQueryString: (NSString*) queryString
                 clearResultsOnStart: (BOOL) clearResultsOnStart
                       queryObserver: (WRLDSearchQueryObserver *) queryObserver;

- (instancetype) initWithQueryString: (NSString*) queryString
                        queryContext: (id<NSObject>) queryContext
                 clearResultsOnStart: (BOOL) clearResultsOnStart
                       queryObserver: (WRLDSearchQueryObserver *) queryObserver;

@property (nonatomic, readonly) BOOL clearResultsOnStart;

- (void) dispatchRequestsToSearchProviders: (WRLDSearchRequestFulfillerCollection *) providerHandles;
- (void) dispatchRequestsToSuggestionProviders: (WRLDSearchRequestFulfillerCollection *) providerHandles;

- (void) addResults: (WRLDSearchResultsCollection *) results fromFulfiller: (id<WRLDSearchRequestFulfillerHandle>) fulfillerHandle withSuccess: (BOOL) success;

- (void) cancelRequest: (WRLDSearchRequest *) cancelledRequest;
@end


