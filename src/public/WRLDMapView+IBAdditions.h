#pragma once

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (IBAdditions)

// Properties for use inside Interface Builder for setting the initial location and orientation of the map.

/*! The latitude in degrees of the location that the map is initially centered on - for use inside Interface Builder only.
*/
@property (nonatomic) IBInspectable double startLatitude;

/*! The longitude in degrees of the location that the map is initially centered on - for use inside Interface Builder only.
 */
@property (nonatomic) IBInspectable double startLongitude;

/*! The zoom level that the map will initially be displayed with - for use inside Interface Builder only.
 */
@property (nonatomic) IBInspectable double startZoomLevel;

/*! The direction in degrees clockwise from north of the initial map view - for use inside Interface Builder only.
 */
@property (nonatomic) IBInspectable double startDirection;

@end

NS_ASSUME_NONNULL_END
