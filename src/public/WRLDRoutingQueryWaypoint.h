#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A waypoint for the routing query.
 */
@interface WRLDRoutingQueryWaypoint : NSObject

/*!
 @returns The geographic location for this waypoint.
 */
- (CLLocationCoordinate2D) latLng;

/*!
 @returns Whether this waypoint is indoors or not.
 */
- (BOOL) isIndoors;

/*!
 @returns If indoors, the ID of the floor this waypoint is on.
 */
- (int) indoorFloorId;

@end

NS_ASSUME_NONNULL_END
