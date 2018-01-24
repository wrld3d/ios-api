#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Represents a building or part of building as a polygon with minimum and maximum altitudes.
 This can be used to construct an extruded polygon (prism) to visually represent the building.
 Complex buildings may be made up of multiple WRLDBuildingContour.
 */
@interface WRLDBuildingContour : NSObject

/*!
 @returns The minimum altitude above sea level.
 */
- (CLLocationDistance) bottomAltitude;

/*!
 @returns The maximum altitude above sea level.
 */
- (CLLocationDistance) topAltitude;

/*!
 @returns The vertices of the building outline polygon, ordered clockwise from above.
 */
- (CLLocationCoordinate2D*) points;

/*!
 @returns The count of CLLocationCoordinate2D points.
 */
- (int) pointCount;

@end

NS_ASSUME_NONNULL_END
