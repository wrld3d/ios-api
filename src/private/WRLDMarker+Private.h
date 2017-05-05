#pragma once

#import "WRLDMarkerOptions.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDMapView;
@class WRLDMarker;

@interface WRLDMarker (Private)

- (instancetype)initWithMarkerOptions:(WRLDMarkerOptions *)markerOptions
                      andAddToMapView:(WRLDMapView*) mapView;

@end

NS_ASSUME_NONNULL_END
