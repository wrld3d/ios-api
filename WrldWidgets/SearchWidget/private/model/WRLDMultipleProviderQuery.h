#pragma once

#include "WRLDSearchQuery+Private.h"
#include "WRLDSearchTypes.h"

@protocol WRLDSearchResultsReadyDelegate;
@protocol WRLDSearchResultModel;
@protocol WRLDQueryFulfillerHandle;

@interface WRLDMultipleProviderQuery : WRLDSearchQuery

-(instancetype) initWithQuery:(NSString*) queryString forSearchProviders:(WRLDSearchProviderCollection *) providerHandles callingOnCompletion:(id<WRLDSearchResultsReadyDelegate>) completionDelegate;

-(instancetype) initWithQuery:(NSString*) queryString forSuggestionProviders:(WRLDSuggestionProviderCollection *) providerHandles callingOnCompletion:(id<WRLDSearchResultsReadyDelegate>) completionDelegate;

-(void) addResults:(WRLDSearchResultsCollection *) results fromFulfiller:(id<WRLDQueryFulfillerHandle>) fulfillerHandle withSuccess:(BOOL) success;

@end



