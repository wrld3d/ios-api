#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/// This type contains information about a projected point on a path.
@interface WRLDPointOnPathResult : NSObject

/// The closest point on the Path to the target point.
@property (nonatomic, readonly) CLLocationCoordinate2D resultPoint;

/// The original target point tested against.
@property (nonatomic, readonly) CLLocationCoordinate2D inputPoint;

/// Absolute distance from the input point (in ECEF space).
@property (nonatomic, readonly) double distanceFromInputPoint;

/// Fraction that the projected point travelled along current path segment.
@property (nonatomic, readonly) double fractionAlongPath;

/// Index of the start vertex of the current path segment.
@property (nonatomic, readonly) int indexOfPathSegmentStartVertex;

/// Index of the end vertex of the current path segment.
@property (nonatomic, readonly) int indexOfPathSegmentEndVertex;

@end

NS_ASSUME_NONNULL_END
