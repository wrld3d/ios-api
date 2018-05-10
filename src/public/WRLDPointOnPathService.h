#pragma once

#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "WRLDRoute.h"
#import "WRLDPointOnRoute.h"


NS_ASSUME_NONNULL_BEGIN

/*!
 A service which allows you to find the closest point on a path or route. Created by the createPointOnPathService
 method of the WRLDMapView object.
 */
@interface WRLDPointOnPathService : NSObject

/*!
 Find the closest point on a path to a provided target point.
 

 @param path The path to test against; an array of CLLocationCoordinates.
 @param count The number of elements in the path array.
 @param point The desired target point.
 @returns The closest point on the path to the provided target point.
 */
- (CLLocationCoordinate2D) getPointOnPath:(CLLocationCoordinate2D *)path
                           count:(NSInteger)count
                           point:(CLLocationCoordinate2D)point ;

/*!
 Find the approximate fraction along a path that a provided target point has travelled.
 

 @param path The path to test against; an array of CLLocationCoordinates.
 @param count The number of elements in the path array.
 @param point The desired target point.
 @returns The fractional value that the point has travelled, from 0 - 1.
 */
- (CGFloat) getPointFractionAlongPath:(CLLocationCoordinate2D *)path
                                count:(NSInteger)count
                                point:(CLLocationCoordinate2D)point ;

/*!
 Retrieve information about the closest point on a WRLDRoute to a provided target point.
 

 @param route The WRLDRoute to test against.
 @param point The desired target point.
 @returns The WRLDPointOnRoute that represents information about that point, or nil if no suitable point is found.
 */
- (WRLDPointOnRoute*) getPointOnRoute:(WRLDRoute *)route
                                point:(CLLocationCoordinate2D)point;

/*!
 Retrieve information about the closest point on a WRLDRoute to a provided target point on an Indoor Map.
 

 @param route The WRLDRoute to test against.
 @param point The desired target point.
 @param indoorMapId The Indoor Map Id string that the target point is located within.
 @param indoorMapFloorId The indoor map floor id that the target point is located on.
 @returns The WRLDPointOnRoute that represents information about that point, or nil if no suitable point is found.
 */
- (WRLDPointOnRoute*) getPointOnRoute:(WRLDRoute *)route
                                point:(CLLocationCoordinate2D)point
                                withIndoorMapId:(NSString*)indoorMapId
                                indoorMapFloorId:(NSInteger)indoorMapFloorId;

@end

NS_ASSUME_NONNULL_END

