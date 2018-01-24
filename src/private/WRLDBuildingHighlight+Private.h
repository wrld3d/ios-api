#pragma once

#import "WRLDBuildingHighlight.h"
#import "WRLDBuildingHighlightOptions.h"

#include "EegeoBuildingsApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingHighlight;

@interface WRLDBuildingHighlight (Private)

- (instancetype) initWithApi:(Eegeo::Api::EegeoBuildingsApi&)buildingsApi
    buildingHighlightOptions:(WRLDBuildingHighlightOptions*)buildingHighlightOptions;

- (void) destroy;

- (int) buildingHighlightId;

- (void) loadBuildingInformationFromNative;

@end

NS_ASSUME_NONNULL_END
