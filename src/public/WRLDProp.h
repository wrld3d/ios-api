#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"


NS_ASSUME_NONNULL_BEGIN

/// A Prop is a 3d mesh, placed on or above the map.
@interface WRLDProp : NSObject<WRLDOverlay>

/*!
 Instantiate a prop.
 @param name The name assigned to this prop - this should be unique.
 @param geometryId The name of the geometry to be rendered.  Available geometry is currently curated by WRLD, please get in touch via support@wrld3d.com to discuss additions.
 @param location The location for the prop
 @param indoorMapId The id of the indoor map the prop will be displayed on
 @param indoorMapFloorId The id of the floor of the indoor map on which to display the prop
 @param elevation The elevation of the prop, in metres above ground of sea-level, depending on the value of elevationMode
 @param elevationMode Specifies how the elevation property of this prop is interpreted
 @param headingDegrees The direction in which the prop should face, in degrees, clockwise from North (0 degrees)
 @returns A WRLDProp instance.
 */
+ (instancetype)propWithName:(NSString *)name
                  geometryId:(NSString *)geometryId
                    location:(CLLocationCoordinate2D)location
                 indoorMapId:(NSString *)indoorMapId
            indoorMapFloorId:(int)indoorMapFloorId
                   elevation:(CLLocationDistance)elevation
               elevationMode:(WRLDElevationMode)elevationMode
              headingDegrees:(double)headingDegrees;

/*!
 Instantiate a prop.
 @param name The name assigned to this prop - this should be unique.
 @param geometryId The name of the geometry to be rendered.  Available geometry is currently curated by WRLD, please get in touch via support@wrld3d.com to discuss additions.
 @param location The location for the prop
 @param indoorMapId The id of the indoor map the prop will be displayed on
 @param indoorMapFloorId The id of the floor of the indoor map on which to display the prop
 
 @returns A WRLDProp instance, with default elevation (0), elevation Mode (height above ground) and heading (0 degrees, pointing North).
 */
+ (instancetype)propWithName:(NSString *)name
                  geometryId:(NSString *)geometryId
                    location:(CLLocationCoordinate2D)location
                 indoorMapId:(NSString *)indoorMapId
            indoorMapFloorId:(int)indoorMapFloorId;

/// The name assigned to the prop, this should be unique.
@property (nonatomic, readonly) NSString* name;

/// The id of the geometry to be rendered in the prop's location.
@property (nonatomic, copy) NSString* geometryId;

/// The height of the prop above either the ground, or sea-level, depending on the elevationMode property.
@property (nonatomic) CLLocationCoordinate2D location;

/// The id of the indoor map on which to display the prop.
@property (nonatomic, readonly) NSString* indoorMapId;

/// The floor id of the floor on which the prop will be displayed
@property (nonatomic, readonly) NSInteger indoorFloorId;

/// The height of the prop above either the ground, or sea-level, depending on the elevationMode property.
@property (nonatomic) CLLocationDistance elevation;

/*!
 Specifies how the elevation property of this prop is interpreted:
 
 - `WRLDElevationModeHeightAboveSeaLevel`: The elevation is an absolute altitude above mean sea level, in meters.
 - `WRLDElevationModeHeightAboveGround`: The elevation is a height relative to the map's terrain, in meters.
 */
@property (nonatomic) WRLDElevationMode elevationMode;

/// An angle in degrees, clockwise from North (0 degrees) specifying the direction in which the prop faces.
@property (nonatomic) double headingDegrees;

@end

NS_ASSUME_NONNULL_END
