#pragma once

#include "EegeoApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDPositioner;

@interface WRLDPositioner (Private)

- (void)notifyPositionerProjectionChanged;

@end

NS_ASSUME_NONNULL_END

