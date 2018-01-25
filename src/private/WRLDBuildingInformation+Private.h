#pragma once

#import "WRLDBuildingInformation.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingInformation;

@interface WRLDBuildingInformation (Private)

- (instancetype) initWithBuildingId:(NSString*)buildingId
                 buildingDimensions:(WRLDBuildingDimensions*)buildingDimensions
                           contours:(NSArray<WRLDBuildingContour*>*)contours;

@end

NS_ASSUME_NONNULL_END
