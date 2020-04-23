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

 @returns An array of the individual CLLocationCoordinate2D points that make up this step.
 */
 - (CLLocationCoordinate2D*) path;

/*!
 @returns The count of CLLocationCoordinate2D points that make up this path.
 */
- (int) pathCount;

/*!
 @returns The directions associated with this step.
 */
- (WRLDRouteDirections*) directions;

/*!
 Specifies the mode of transport for this step:
 - `WRLDWalking`: Indicates that the route is a walking WRLDRoute.

 @returns The mode of transport for this step.
 */
- (WRLDRouteTransportationMode) mode;

/*!
 @returns Whether this step is indoors or not.
 */
- (BOOL) isIndoors;

/*!
 @returns If indoors, the ID of the indoor map this step is inside.
 */
- (NSString*) indoorId;

/*!
 @returns If indoors, the ID of the floor this step is on.
 */
- (int) indoorFloorId;

/*!
 @returns If indoors, this step represents moving between the floors of the previous and next steps.
 */
- (BOOL) isMultiFloor;

/*!
 @returns The estimated time this step will take to travel in seconds.
 */
- (NSTimeInterval) duration;

/*!
 @returns The estimated distance this step covers in meters.
 */
- (CLLocationDistance) distance;

/*!
 @returns If available, the name of the location this step is on.
 */
- (NSString*) stepName;

@end

NS_ASSUME_NONNULL_END
