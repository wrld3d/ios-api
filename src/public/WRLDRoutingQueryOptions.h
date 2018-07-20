#pragma once

#import <CoreLocation/CoreLocation.h>
#import "WRLDRouteTransportationMode.h"

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

/*!
 Set the desired transportation mode for the route, e.g. Walking or Driving. The default mode is Walking.
 
 @param transportationMode An Enum that represents transportationMode, e.g Walking or Driving.
*/
- (void)setTransportationMode:(WRLDRouteTransportationMode)transportationMode;

/*!
 Gets the transportationMode for the type of route that should be queried, e.g. Walking or Driving.
 
 @returns The transportation mode in this query.
 */
- (WRLDRouteTransportationMode)getTransportationMode;

@end

NS_ASSUME_NONNULL_END
