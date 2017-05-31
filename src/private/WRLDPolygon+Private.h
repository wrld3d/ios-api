#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDMapView;

@interface WRLDPolygon (Private)

- (void)addToMapView:(WRLDMapView *)mapView;

- (void)removeFromMapView;

- (int)getId;

- (bool)isOnMapView;

@end

NS_ASSUME_NONNULL_END
