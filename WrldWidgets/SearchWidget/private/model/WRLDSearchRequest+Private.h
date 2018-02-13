#pragma once

#include "WRLDSearchRequest.h"

@protocol WRLDQueryFulfillerHandle;
@class WRLDSearchQuery;

@interface WRLDSearchRequest (Private)
-(instancetype) initWithFulfillerHandle: (id<WRLDQueryFulfillerHandle>) fulfillerHandle forQuery:(WRLDSearchQuery *) query;
@end
