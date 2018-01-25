#pragma once

#import "WRLDBuildingHighlight.h"
#import "WRLDBuildingHighlightOptions.h"

#include "EegeoBuildingsApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingHighlight;

@interface WRLDBuildingHighlight (Private)

- (instancetype) initWithHighlightOptions:(WRLDBuildingHighlightOptions*)buildingHighlightOptions;

- (int) buildingHighlightId;

- (void) loadBuildingInformationFromNative;

@end

NS_ASSUME_NONNULL_END
