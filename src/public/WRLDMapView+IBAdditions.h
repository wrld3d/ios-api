#pragma once

#import <Foundation/Foundation.h>

#import "WRLDMapView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (IBAdditions)

/// The latitude in degrees that the map is currently centered on.
@property (nonatomic) IBInspectable double latitude;

/// The longitude in degrees that the map is currently centered on.
@property (nonatomic) IBInspectable double longitude;

/// The current zoom level of the map.
@property (nonatomic) IBInspectable double zoomLevel;

/// The current heading direction of the map, in degrees.
@property (nonatomic) IBInspectable double direction;

@end

NS_ASSUME_NONNULL_END
