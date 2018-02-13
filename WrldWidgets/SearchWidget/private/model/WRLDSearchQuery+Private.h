#pragma once

#include "WRLDSearchQuery.h"
#include "WRLDSearchTypes.h"

@class WRLDSearchModelQueryDelegate;
@protocol WRLDQueryFulfillerHandle;

@interface WRLDSearchQuery (Private)

- (instancetype) initWithQueryString: (NSString*) queryString queryDelegate: (WRLDSearchModelQueryDelegate *) queryDelegate;

- (void) dispatchRequestsToSearchProviders: (WRLDSearchProviderCollection *) providerHandles;
- (void) dispatchRequestsToSuggestionProviders: (WRLDSuggestionProviderCollection *) providerHandles;

- (void) addResults: (WRLDSearchResultsCollection *) results fromFulfiller: (id<WRLDQueryFulfillerHandle>) fulfillerHandle withSuccess: (BOOL) success;

- (void) cancel: (id<WRLDQueryFulfillerHandle>) cancelledFulfiller;
@end


