#pragma once

#include "EegeoPoiApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDPoiService;

@interface WRLDPoiService (Private)

- (instancetype)initWithApi:(Eegeo::Api::EegeoPoiApi&)poiApi;

@end

NS_ASSUME_NONNULL_END
