#pragma once

#import "WRLDIndoorMapEntityInformation.h"

#include "EegeoIndoorEntityInformationApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDIndoorMapEntityInformation;

@interface WRLDIndoorMapEntityInformation (Private)

- (instancetype) initWithIndoorMapId:(NSString*)indoorMapId;

- (int) indoorMapEntityInformationId;

- (void) loadIndoorMapEntityInformationFromNative;

@end

NS_ASSUME_NONNULL_END
