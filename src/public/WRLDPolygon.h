#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"

NS_ASSUME_NONNULL_BEGIN


/// A Polygon is an shape consisting of three or more vertivces and is placed on or above the map.
/// Optionally polygons can contain one or more interior polygons which define cutout regions in the polygon.
/// Their color can also be modified.
@interface WRLDPolygon : NSObject

/*!
 Instantiate a polygon with coordinates.
 @param coords The array of coordinates that define the polygon. The data in this
 array is copied to the new object.
 @param count The number of items in the coordinates array.
 @returns A WRLDPolygon instance.
 */
+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;

/*!
 Instantiate a polygon with coordinates.
 @param coords The array of coordinates that define the perimeter of the polygon.
 @param count The number of items in the coordinates array.
 @param interiorPolygons An array of WRLDPolygon objects that define cutout regions in the polygon.
 @returns A WRLDPolygon instance.
 */
+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
                      interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons;

/// The color of the polygon.
@property (nonatomic) UIColor* color;

/// The height of the polygon above either the ground, or sea-level, depending on the elevationMode property.
@property (nonatomic) CLLocationDistance elevation;

/*!
 Whether this polygon should be positioned relative to the ground, or sea-level.
 Takes one of the following values:
 
 - `WRLDElevationModeHeightAboveSeaLevel`: The polygons elevation should be relative to sea-level.
 - `WRLDElevationModeHeightAboveGround`: The polygons elevation should be relative to the ground directly below it.
 */
@property (nonatomic) WRLDElevationMode elevationMode;

@end

NS_ASSUME_NONNULL_END
