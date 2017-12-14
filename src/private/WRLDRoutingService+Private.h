#pragma once

#include "EegeoRoutingApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDRoutingService;

@interface WRLDRoutingService (Private)

- (instancetype)initWithApi:(Eegeo::Api::EegeoRoutingApi&)routingApi;

@end

NS_ASSUME_NONNULL_END
