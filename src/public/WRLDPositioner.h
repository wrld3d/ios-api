#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"
#import "WRLDPositionerDelegate.h"

NS_ASSUME_NONNULL_BEGIN


/// A Positioner is an icon placed at a point on or above the map’s surface.
/// They can have some title text attached to them, and can additionally be placed indoors.
@interface WRLDPositioner : NSObject

@property (nonatomic) id <WRLDPositionerDelegate> delegate;

+ (instancetype)positionerAtCoordinate:(CLLocationCoordinate2D)coordinate;

/*!
 Instantiate a positioner at a given location, optionally indoors.
 @param coordinate The coordinate to place this positioner at.
 @param indoorMapId The ID of an indoor map this positioner should be inside. (See WRLDIndoorMap).
 @param floorId An index specifying which floor of the indoor map this positioner should be on. (See WRLDIndoorMap).
 @returns A WRLDPositioner instance.
 */
+ (instancetype)positionerAtCoordinate:(CLLocationCoordinate2D)coordinate
                       inIndoorMap:(NSString *)indoorMapId
                           onFloor:(NSInteger)floorId;

/// The location of the positioner.
@property (nonatomic) CLLocationCoordinate2D coordinate;

/// The height of the positioner above either the ground, or sea-level, depending on the elevationMode property.
@property (nonatomic) CLLocationDistance elevation;

/*!
 Specifies how the elevation property of this positioner is interpreted:
 
 - `WRLDElevationModeHeightAboveSeaLevel`: The elevation is an absolute altitude above mean sea level, in meters.
 - `WRLDElevationModeHeightAboveGround`: The elevation is a height relative to the map's terrain, in meters.
 */
@property (nonatomic) WRLDElevationMode elevationMode;

/// The ID of the indoor map this positioner is associated with - if any.
@property (nonatomic, readonly, copy) NSString* indoorMapId;

/// The index of the floor this positioner is associated with - if any.
@property (nonatomic, readonly) NSInteger indoorFloorId;

/*!
 Returns the screen point. Use screenPointProjectionDefined() to check that this point is valid
 and not over the horizon.
 */
- (nullable CGPoint *) screenPointOrNull;


- (nullable WRLDCoordinateWithAltitude *) transformedPointOrNull;

/*!
 Returns true if the screen point is valid for drawing. This returns true if the screen point is
 valid and is on this side of the horizon. The screen point may be outwith the screen area.

 @returns True if the screen point is valid for drawing.
 */
- (BOOL) screenPointProjectionDefined;

- (BOOL) behindGlobeHorizon;

@end

NS_ASSUME_NONNULL_END

