#pragma once

#import "WRLDBuildingContour.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingContour;

@interface WRLDBuildingContour (Private)

- (instancetype) initWithBottomAltitude:(CLLocationDistance)bottomAltitude
                            topAltitude:(CLLocationDistance)topAltitude
                                 points:(CLLocationCoordinate2D*)points
                             pointCount:(int)pointCount;

@end

NS_ASSUME_NONNULL_END
