#pragma once

#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "WRLDRoute.h"
#import "WRLDPointOnRouteInfo.h"


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


- (WRLDPointOnRouteInfo*) getPointOnRoute:(WRLDRoute *)route
                                point:(CLLocationCoordinate2D)point;

@end

NS_ASSUME_NONNULL_END

