#pragma once

#import <CoreLocation/CoreLocation.h>
#import "WRLDMapView.h"

NS_ASSUME_NONNULL_BEGIN

/*! A type to provide conversion between floor plans map coordinates and
 * world coordinate types. Given three points with both their latlong coordinates
 * and their points in the indoor floor map coordinate system, other floor map points can
 * be converted to latlongs.
 */
@interface WRLDIndoorGeoreferencer : NSObject

/*!
 *Instantiate a converter for a set of reference coordinates
 * @param point1LatLong LatLong (in degrees) for 1st point in world space
 * @param point1mapX X coordinate for 1st point in map space
 * @param point1mapY Y coordinate for 1st point in map space
 * @param point2LatLong LatLong (in degrees) for 2nd point in world space
 * @param point2mapX X coordinate for 2nd point in map space
 * @param point2mapY Y coordinate for 2nd point in map space
 * @param point3LatLong LatLong (in degrees) for 3rd point in world space
 * @param point3mapX X coordinate for 3rd point in map space
 * @param point3mapY Y coordinate for 3rd point in map space
 * @param mapView WRLD map view
 * @returns A WrldIndoorGeoreferencer instance
 */
- (instancetype) init   : (CLLocationCoordinate2D) point1LatLong
    point1mapX: (float) point1mapX
    point1mapY: (float) point1mapY
 point2LatLong: (CLLocationCoordinate2D) point2LatLong
    point2mapX: (float) point2mapX
    point2mapY: (float) point2mapY
 point3LatLong: (CLLocationCoordinate2D) point3LatLong
    point3mapX: (float) point3mapX
    point3mapY: (float) point3mapY
       mapView: (WRLDMapView*) mapView;
/*!
 * Convert a coordinate in floor space to world space latlng.
 * @param mapX X coordinate in map space
 * @param mapY Y coordinate in map space
 * @returns CLLocationCoordinate2D of position in world space latlng.
 */
- (CLLocationCoordinate2D) mapPointToLatLong: (float) mapX
                                          mapY: (float) mapY;


@end

NS_ASSUME_NONNULL_END
