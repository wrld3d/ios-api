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
 The minimum altitude above sea level.
 */
@property (nonatomic, readonly) CLLocationDistance bottomAltitude;

/*!
 The maximum altitude above sea level.
 */
@property (nonatomic, readonly) CLLocationDistance topAltitude;

/*!
 The count of CLLocationCoordinate2D points in this contour.
 */
@property (nonatomic, readonly) NSUInteger pointCount;

/*!
 Get points that are vertices of the building outline polygon, ordered clockwise from above.

 @param coordinates The array of coordinates for points. It must be large enough to hold the coordinates.
 */

- (void)getPoints:(CLLocationCoordinate2D *)coordinates;

@end

NS_ASSUME_NONNULL_END
