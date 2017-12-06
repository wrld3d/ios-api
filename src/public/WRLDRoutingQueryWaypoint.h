#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A waypoint for the routing query.
 */
@interface WRLDRoutingQueryWaypoint : NSObject

/*!
 The geographic location for this waypoint.
 */
@property (nonatomic) CLLocationCoordinate2D latLng;

/*!
 Whether this waypoint is indoors or not.
 */
@property (nonatomic) BOOL isIndoors;

/*!
 If indoors, the ID of the floor this waypoint is on.
 */
@property (nonatomic) int indoorFloorId;

@end

NS_ASSUME_NONNULL_END
