#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"

#import "WRLDOverlay.h"

NS_ASSUME_NONNULL_BEGIN


/// A Marker is an icon placed at a point on or above the map’s surface.
/// They can have some title text attached to them, and can additionally be placed indoors.
@interface WRLDMarker : NSObject<WRLDOverlay>

+ (instancetype)markerAtCoordinate:(CLLocationCoordinate2D)coordinate;

/*!
 Instantiate a marker at a given location, optionally indoors.
 @param coordinate The coordinate to place this marker at.
 @param indoorMapId The ID of an indoor map this marker should be inside. (See WRLDIndoorMap).
 @param floorId An index specifying which floor of the indoor map this marker should be on. (See WRLDIndoorMap).
 @returns A WRLDMarker instance.
 */
+ (instancetype)markerAtCoordinate:(CLLocationCoordinate2D)coordinate
                       inIndoorMap:(NSString *)indoorMapId
                           onFloor:(NSInteger)floorId;

/// The location of the marker.
@property (nonatomic) CLLocationCoordinate2D coordinate;

/// The height of the marker above either the ground, or sea-level, depending on the elevationMode property.
@property (nonatomic) CLLocationDistance elevation;

/*!
 Specifies how the elevation property of this marker is interpreted:
 
 - `WRLDElevationModeHeightAboveSeaLevel`: The elevation is an absolute altitude above mean sea level, in meters.
 - `WRLDElevationModeHeightAboveGround`: The elevation is a height relative to the map's terrain, in meters.
 */
@property (nonatomic) WRLDElevationMode elevationMode;

/// When markers overlap, this property determines which one appears on top of the other.
@property (nonatomic) NSInteger drawOrder;

/// The text label to display next to the marker.
@property (nonatomic, copy) NSString* title;

/// The name of the label style to use. The list of supported styles has not been stabilized yet and this can be left as the default value.
@property (nonatomic, copy) NSString* styleName;

/// Optional JSON user data associated with this marker.
@property (nonatomic, copy) NSString* userData;

/// A string used to determine which icon is displayed for this marker.
@property (nonatomic, copy) NSString* iconKey;

/// The ID of the indoor map this marker is associated with - if any.
@property (nonatomic, readonly, copy) NSString* indoorMapId;

/// The index of the floor this marker is associated with - if any.
@property (nonatomic, readonly) NSInteger indoorFloorId;

@end

NS_ASSUME_NONNULL_END
