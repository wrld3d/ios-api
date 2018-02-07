#pragma once

#import "WRLDBuildingContour.h"

#include <vector>

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingContour;

@interface WRLDBuildingContour (Private)

- (instancetype) initWithBottomAltitude:(CLLocationDistance)bottomAltitude
                            topAltitude:(CLLocationDistance)topAltitude
                                 points:(std::vector<CLLocationCoordinate2D>)points;

@end

NS_ASSUME_NONNULL_END
