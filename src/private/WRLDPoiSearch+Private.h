#pragma once

#import <Foundation/Foundation.h>

#include "EegeoPoiApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDPoiSearch;

@interface WRLDPoiSearch (Private)

- (instancetype)initWithIdAndApi:(int)searchId poiApi:(Eegeo::Api::EegeoPoiApi&)poiApi;

@end

NS_ASSUME_NONNULL_END
