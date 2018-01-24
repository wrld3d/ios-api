#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"

#import "WRLDOverlay.h"

NS_ASSUME_NONNULL_BEGIN

/// A shape comprising one or more connected line segments. Points are connected in the order of supplied coordinates. The first and
/// last point are not automatically connected.
/// A Polyine's lineWidth and color can be modified.
@interface WRLDPolyline : NSObject<WRLDOverlay>

/*!
 Instantiate a polyline with coordinates.
 @param coords The array of coordinates that define the polyline. The data in this
 array is copied to the new object.
 @param count The number of items in the coordinates array.
 @returns A WRLDPolyline instance.
 */
+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;


/*!
 Instantiate a polyline with coordinates on an indoor map
 @param coords The array of coordinates that define the polyline. The data in this
 array is copied to the new object.
 @param count The number of items in the coordinates array.
 @param indoorMapId The id of the indoor map on which the polyline will be displayed.
 @param floorId The id of the indoor map floor on which the polyline will be displayed.
 @returns A WRLDPolyline instance.
 */
+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
                           onIndoorMap:(NSString *)indoorMapId
                               onFloor:(NSInteger)floorId;

/*!
 Sets the perPointElevations on a polyline
 @param perPointElevations The array of CGFloats that define a polyline's perPointElevations.
 These are used to create vertical polylines.
 @param count The number of perPointElevations for the polyline.
 */
- (void)setPerPointElevations:(CGFloat *)perPointElevations
                        count:(NSUInteger)count;


/// The color of the polyline. The default value is opaque black.
@property (nonatomic, copy) UIColor* color;

/// The thickness in pixels of the polyline. The default value is 10.
@property (nonatomic) CGFloat lineWidth;

/*! A value used to limit the extent of spikes where line segments join at small
 (acute) angles. The value of miterLimit represents the maximum ratio between the
 length of the miter join diagonal, and lineWidth. The default value is 10, which
 results in clamping of the miter diagonal when the join angle is less than
 approximately 11 degrees.
 */
@property (nonatomic) CGFloat miterLimit;

/// If YES, line width scales with perspective as the map viewpoint zooms in and out (default NO)
@property (nonatomic) Boolean scalesWithMap;

/*! The height of the polyline above either the ground, or sea-level, depending on the elevationMode property.
 The default value is 0
 */
@property (nonatomic) CLLocationDistance elevation;

/*!
 Specifies how the elevation property of this polyline is interpreted:
 
 - `WRLDElevationModeHeightAboveSeaLevel`: The elevation is an absolute altitude above mean sea level, in meters.
 - `WRLDElevationModeHeightAboveGround`: The elevation is a height relative to the map's terrain, in meters.
 
 The default value is WRLDElevationModeHeightAboveGround
 */
@property (nonatomic) WRLDElevationMode elevationMode;


/// For a polyline to be displayed on an indoor map, the id of the indoor map (else nil).
@property (nonatomic, copy) NSString* indoorMapId;

/// For an indoor map polyline, the floor id of the floor on which the polyline will be displayed
@property (nonatomic) NSInteger indoorFloorId;

@end

NS_ASSUME_NONNULL_END
