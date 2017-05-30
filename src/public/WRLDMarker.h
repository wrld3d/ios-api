#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"

NS_ASSUME_NONNULL_BEGIN


/// A Marker is an icon placed at a point on or above the map’s surface.
/// They can have some title text attached to them, and can additionally be placed indoors.
@interface WRLDMarker : NSObject

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
 Whether this marker should be positioned relative to the ground, or sea-level.
 Takes one of the following values:
 
 - `WRLDElevationModeHeightAboveSeaLevel`: The markers elevation should be relative to sea-level.
 - `WRLDElevationModeHeightAboveGround`: The markers elevation should be relative to the ground directly below it.
 */
@property (nonatomic) WRLDElevationMode elevationMode;

/// When markers overlap, this property determines which one appears on top of the other.
@property (nonatomic) NSInteger drawOrder;

/// The text label to display next to the marker.
@property (nonatomic, copy) NSString* title;

/// The name of the label style to use. The list of supported styles has not been stabilized yet and this can be left as the default value.
@property (nonatomic, readonly, copy) NSString* styleName;

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
