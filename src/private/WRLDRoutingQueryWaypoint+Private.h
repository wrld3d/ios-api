#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDRoutingQueryWaypoint;

@interface WRLDRoutingQueryWaypoint (Private)

- (instancetype)initWithLatLng:(CLLocationCoordinate2D)latLng
                     isIndoors:(BOOL)isIndoors
                 indoorFloorId:(int)indoorFloorId;

@end

NS_ASSUME_NONNULL_END
