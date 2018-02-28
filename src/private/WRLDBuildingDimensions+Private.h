#pragma once

#import "WRLDBuildingDimensions.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingDimensions;

@interface WRLDBuildingDimensions (Private)

- (instancetype) initWithBaseAltitude:(CLLocationDistance)baseAltitude
                          topAltitude:(CLLocationDistance)topAltitude
                             centroid:(CLLocationCoordinate2D)centroid;

@end

NS_ASSUME_NONNULL_END
