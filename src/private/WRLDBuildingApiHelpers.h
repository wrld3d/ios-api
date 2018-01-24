#pragma once

#include <vector>

#include "BuildingHighlightCreateParams.h"
#include "BuildingInformation.h"
#include "BuildingDimensions.h"
#include "BuildingContour.h"
#include "LatLongAltitude.h"

#import <Foundation/Foundation.h>

#import "WRLDBuildingHighlightOptions.h"
#import "WRLDBuildingDimensions.h"
#import "WRLDBuildingInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDBuildingApiHelpers : NSObject

+ (Eegeo::BuildingHighlights::BuildingHighlightCreateParams) createBuildingHighlightCreateParams:(WRLDBuildingHighlightOptions*) withBuildingHighlightOptions;

+ (WRLDBuildingDimensions*) createWRLDBuildingDimensions:(const Eegeo::BuildingHighlights::BuildingDimensions&) withBuildingDimensions;

+ (CLLocationCoordinate2D*)createWRLDBuildingContourPoints:(const std::vector<Eegeo::Space::LatLong>&) withPoints;

+ (NSMutableArray*) createWRLDBuildingContours:(const std::vector<Eegeo::BuildingHighlights::BuildingContour>&) withBuildingContours;

+ (WRLDBuildingInformation*) createWRLDBuildingInformation:(const Eegeo::BuildingHighlights::BuildingInformation&) withBuildingInformation;

@end

NS_ASSUME_NONNULL_END
