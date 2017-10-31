#pragma once

#include "EegeoApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDPositioner;

@interface WRLDPositioner (Private)

- (void) createNative:(Eegeo::Api::EegeoMapApi&) mapApi;

- (void) destroyNative;

- (bool)nativeCreated;

- (int) getPositionerId;

- (void)notifyPositionerProjectionChanged;

@end

NS_ASSUME_NONNULL_END

