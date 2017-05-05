#pragma once

#import "WRLDMarkerOptions.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDMapView;

@interface WRLDMarker : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

NS_ASSUME_NONNULL_END
