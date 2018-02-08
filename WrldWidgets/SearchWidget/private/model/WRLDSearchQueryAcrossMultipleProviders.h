#pragma once

#include "WRLDSearchQuery+Private.h"
#include "WRLDQueryFulfiller.h"

@interface WRLDSearchQueryAcrossMultipleProviders<T: id<WRLDQueryFulfiller>> : WRLDSearchQuery
-(instancetype) initWithQuery:(NSString*) queryString forProviders:(NSArray<id<WRLDQueryFulfiller>>*) providerReferences;
-(void) addResults:(NSArray<WRLDSearchResultModel*>*) results fromProvider:(id<WRLDQueryFulfiller>) providerReference;
@end



