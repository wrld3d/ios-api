#pragma once

#import <Foundation/Foundation.h>

#include "EegeoRoutingApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDRoutingQuery;

@interface WRLDRoutingQuery (Private)
- (instancetype)initWithIdAndApi:(int)queryId routingApi:(Eegeo::Api::EegeoRoutingApi&)routingApi;

@end

NS_ASSUME_NONNULL_END
