#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "WRLDRouteDirections.h"
#import "WRLDRouteTransportationMode.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 A single step of a WRLDRoute.
 */
@interface WRLDRouteStep : NSObject

/*!
 An array of the individual CLLocationCoordinate2D points that make up this step.
 This can be a single point if no distance was covered, for example
 a WRLDRouteStep may indicate departure or arrival with a single point.
 */
 @property (nonatomic) CLLocationCoordinate2D* path;

/*!
 The count of CLLocationCoordinate2D points that make up this path.
 */
@property (nonatomic) int pathCount;

/*!
 The directions associated with this step.
 */
@property (nonatomic) WRLDRouteDirections* directions;

/*!
 Specifies the mode of transport for this step:
 - `WRLDWalking`: Indicates that the route is a walking WRLDRoute.
 */
@property (nonatomic) WRLDRouteTransportationMode mode;

/*!
 Whether this step is indoors or not.
 */
@property (nonatomic) BOOL isIndoors;

/*!
 If indoors, the ID of the indoor map this step is inside.
 */
@property (nonatomic, copy) NSString* indoorId;

/*!
 If indoors, the ID of the floor this step is on.
 */
@property (nonatomic) int indoorFloorId;

/*!
 The estimated time this step will take to travel in seconds.
 */
@property (nonatomic) double duration;

/*!
 The estimated distance this step covers in meters.
 */
@property (nonatomic) double distance;

@end

NS_ASSUME_NONNULL_END
