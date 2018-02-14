#pragma once

#include "WRLDSearchQuery.h"
#include "WRLDSearchTypes.h"

@class WRLDSearchModelQueryDelegate;
@class WRLDSearchRequest;
@protocol WRLDSearchRequestFulfillerHandle;

@interface WRLDSearchQuery (Private)

- (instancetype) initWithQueryString: (NSString*) queryString queryDelegate: (WRLDSearchModelQueryDelegate *) queryDelegate;

- (void) dispatchRequestsToSearchProviders: (WRLDSearchRequestFulfillerCollection *) providerHandles;
- (void) dispatchRequestsToSuggestionProviders: (WRLDSearchRequestFulfillerCollection *) providerHandles;

- (void) addResults: (WRLDSearchResultsCollection *) results fromFulfiller: (id<WRLDSearchRequestFulfillerHandle>) fulfillerHandle withSuccess: (BOOL) success;

- (void) cancelRequest: (WRLDSearchRequest *) cancelledRequest;
@end


