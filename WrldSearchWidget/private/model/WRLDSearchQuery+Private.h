#pragma once

#include "WRLDSearchQuery.h"
#include "WRLDSearchTypes.h"

@class WRLDSearchQueryObserver;
@class WRLDSearchRequest;
@protocol WRLDSearchRequestFulfillerHandle;

@interface WRLDSearchQuery (Private)

- (instancetype) initWithQueryString: (NSString*) queryString queryObserver: (WRLDSearchQueryObserver *) queryObserver;
- (instancetype) initWithQueryString: (NSString*) queryString queryContext: (id<NSObject>) queryContext queryObserver: (WRLDSearchQueryObserver *) queryObserver;

- (void) dispatchRequestsToSearchProviders: (WRLDSearchRequestFulfillerCollection *) providerHandles;
- (void) dispatchRequestsToSuggestionProviders: (WRLDSearchRequestFulfillerCollection *) providerHandles;

- (void) addResults: (WRLDSearchResultsCollection *) results fromFulfiller: (id<WRLDSearchRequestFulfillerHandle>) fulfillerHandle withSuccess: (BOOL) success;

- (void) cancelRequest: (WRLDSearchRequest *) cancelledRequest;
@end


