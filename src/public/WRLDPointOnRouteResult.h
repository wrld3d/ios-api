#pragma once

#import <CoreLocation/CoreLocation.h>
#import "WRLDRouteStep.h"
#import "WRLDRouteSection.h"

NS_ASSUME_NONNULL_BEGIN


/// This type contains information about a projected point on a route.
@interface WRLDPointOnRouteResult : NSObject

/// The closest point on the Route to the target point.
@property (nonatomic, readonly) CLLocationCoordinate2D resultPoint;

/// The original target point tested against.
@property (nonatomic, readonly) CLLocationCoordinate2D inputPoint;

/// Absolute distance from the input point (in ECEF space).
@property (nonatomic, readonly) double distanceFromInputPoint;

/// Fraction that the projected point travelled along entire route.
@property (nonatomic, readonly) double fractionAlongRoute;

/// Fraction that the projected point travelled along the route section.
@property (nonatomic, readonly) double fractionAlongRouteSection;

/// Fraction that the projected point travelled along the route step.
@property (nonatomic, readonly) double fractionAlongRouteStep;

/// Route Step that the projected point lies on.
@property (nonatomic, retain, readonly) WRLDRouteStep* routeStep;

/// Route Section that the projected point lies on.
@property (nonatomic, retain, readonly) WRLDRouteSection* routeSection;

/// Index for the Route Step that the projected point lies on.
@property (nonatomic, readonly) int routeStepIndex;

///  Index for the Route Section that the projected point lies on.
@property (nonatomic, readonly) int routeSectionIndex;

/// Index of Path segment start vertex that the projected point lies on.
@property (nonatomic, readonly) int pathSegmentStartVertexIndex;

@end

NS_ASSUME_NONNULL_END
