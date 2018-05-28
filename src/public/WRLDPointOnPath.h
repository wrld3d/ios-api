#pragma once

#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "WRLDRoute.h"
#import "WRLDPointOnRouteResult.h"
#import "WRLDPointOnPathResult.h"
#import "WRLDPointOnRouteOptions.h"


NS_ASSUME_NONNULL_BEGIN

/*!
 A class which allows you to find the closest point on a path or route. Created by the createPointOnPath
 method of the WRLDMapView object.
 */
@interface WRLDPointOnPath : NSObject

/*!
 Find the closest point on a path to a provided target point.
 

 @param path The path to test against; an array of CLLocationCoordinates.
 @param count The number of elements in the path array.
 @param point The desired target point.
 @returns The closest point on the path to the provided target point.
 */
- (WRLDPointOnPathResult*) getPointOnPath:(CLLocationCoordinate2D *)path
                                    count:(NSInteger)count
                                    point:(CLLocationCoordinate2D)point ;

/*!
 Retrieve information about the closest point on a WRLDRoute to a provided target point on an Indoor Map.
 

 @param route The WRLDRoute to test against.
 @param point The desired target point.
 @param options The indoor options for specifying a route that is indoors.
 @returns The WRLDPointOnRouteResult that represents information about that point, or nil if no suitable point is found.
 */
- (WRLDPointOnRouteResult*) getPointOnRoute:(WRLDRoute *)route
                                      point:(CLLocationCoordinate2D)point
                                    options:(WRLDPointOnRouteOptions*)options;

@end

NS_ASSUME_NONNULL_END

