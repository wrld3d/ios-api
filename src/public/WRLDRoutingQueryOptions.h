#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A set of parameters for a WRLDRoutingQuery.
 */
@interface WRLDRoutingQueryOptions : NSObject

/*!
 Add an outdoor waypoint to the route.

 @param latLng A CLLocationCoordinate2D this route should pass through.
 */
- (void)addWaypoint:(CLLocationCoordinate2D)latLng;

/*!
 Add an indoor waypoint to the route.

 @param latLng A CLLocationCoordinate2D this route should pass through.
 @param indoorFloorId The ID of the floor this point lies on.
 */
- (void)addIndoorWaypoint:(CLLocationCoordinate2D)latLng forIndoorFloor:(int)indoorFloorId;

/*!
 Get the list of WRLDRoutingQueryWaypoint objects in this query.

 @returns The waypoints in this query.
 */
- (NSMutableArray*)getWaypoints;

@end

NS_ASSUME_NONNULL_END
