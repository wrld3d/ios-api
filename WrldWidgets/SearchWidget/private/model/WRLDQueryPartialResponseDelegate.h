#pragma once

#include "WRLDSearchResultsReadyDelegate.h"

@protocol WRLDQueryFulfillerHandle;
@class WRLDMultipleProviderQuery;

@interface WRLDQueryPartialResponseDelegate : NSObject<WRLDSearchResultsReadyDelegate>
-(instancetype) initWithFulfillerHandle: (id<WRLDQueryFulfillerHandle>) fulfillerHandle forFullQuery:(WRLDMultipleProviderQuery *) query;
@end
