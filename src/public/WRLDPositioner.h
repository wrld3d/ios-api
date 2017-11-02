#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"
#import "WRLDPositionerDelegate.h"
#import "WRLDCoordinateWithAltitude.h"

#import "WRLDOverlay.h"

NS_ASSUME_NONNULL_BEGIN


/*!
 * A Positioner represents a single point on the map. The primary purpose of a positioner is to
 * expose a point on the map as a 2D coordinate in screen space. This could be used for example to
 * position a View.
 */
@interface WRLDPositioner : NSObject<WRLDOverlay>

/// A WRLDPositionerDelegate object to receive events when the screen point changes.
@property (nonatomic) id <WRLDPositionerDelegate> delegate;

/*!
 Instantiate a positioner at a given location.
 @param coordinate The coordinate to place this positioner at.
 @returns A WRLDPositioner instance.
 */
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

/// The geographic location of the positioner.
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
@property (nonatomic, readonly) NSInteger indoorMapFloorId;

/*!
 Returns the screen point. Use screenPointProjectionDefined() to check that this point is valid
 and not over the horizon.

 @returns The screen point or null.
 */
- (nullable CGPoint *) screenPointOrNull;

/*!
 Returns the geographical coordinate that is used to derive the screen-projected point that is
 accessed with screenPointOrNull. The coordinate may change depending on the animated state of the
 map - for example when displaying in collapsed mode.

 @returns The transformed point or null.
 */
- (nullable WRLDCoordinateWithAltitude *) transformedPointOrNull;

/*!
 Returns true if the screen projection of this positioner would appear beyond the horizon for the
 current viewpoint. For example, when viewing the map zoomed out so that the entire globe is
 visible, calling this method on a Positioner instance located on the opposite side of the Earth to
 the camera location will return true.

 @returns True if the screen point is beyond the horizon.
 */
- (BOOL) behindGlobeHorizon;

/*!
 Returns true if the screen point is valid for drawing. This returns true if the screen point is
 valid and is on this side of the horizon. The screen point may be outwith the screen area.

 @returns True if the screen point is valid for drawing.
 */
- (BOOL) screenPointProjectionDefined;

@end

NS_ASSUME_NONNULL_END

