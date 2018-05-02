#pragma once

#import <CoreLocation/CoreLocation.h>
#import "WRLDRouteStep.h"
#import "WRLDRouteSection.h"

NS_ASSUME_NONNULL_BEGIN


/// This type contains information about a projected point on a route.
@interface WRLDPointOnRouteInfo : NSObject

/// The closest point on the Route to the target point.
@property (nonatomic) CLLocationCoordinate2D projectedPoint;

/// Absolute distance to target point (in ECEF space).
@property (nonatomic) double distanceToTargetPoint;

/// Fraction that the projected point travelled along entire route.
@property (nonatomic) double fractionAlongRoute;

/// Fraction that the projected point travelled along the route section.
@property (nonatomic) double fractionAlongRouteSection;

/// Fraction that the projected point travelled along the route step.
@property (nonatomic) double fractionAlongRouteStep;

/// Route Step that the projected point lies on.
@property (nonatomic, retain) WRLDRouteStep* routeStep;

/// Route Section that the projected point lies on.
@property (nonatomic, retain) WRLDRouteSection* routeSection;

@end

NS_ASSUME_NONNULL_END
