#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDMapView;

@interface WRLDMarker (Private)

- (void)addToMapView:(WRLDMapView *)mapView;

- (void)removeFromMapView;

@end

NS_ASSUME_NONNULL_END
