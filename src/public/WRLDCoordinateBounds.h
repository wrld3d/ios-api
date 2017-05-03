#pragma once

#import <CoreLocation/CoreLocation.h>


/*!
 @struct WRLDCoordinateBounds
 @brief Contains the WGS84 extents of a bounded region of the map.
 */
typedef struct {
    CLLocationCoordinate2D sw;
    CLLocationCoordinate2D ne;
} WRLDCoordinateBounds;

/*!
 @function WRLDCoordinateBoundsMake
 @brief Create an WRLDCoordinateBounds instance from a pair of WGS84 coordinates.
 @param sw The south western point.
 @param ne The north eastern point.
 @return Returns an WRLDCoordinateBounds instance for the region.
 */
WRLDCoordinateBounds WRLDCoordinateBoundsMake(CLLocationCoordinate2D sw, CLLocationCoordinate2D ne);

/*!
 @function WRLDCoordinateBoundsMake
 @brief Create an WRLDCoordinateBounds instance from a collection of WGS84 coordinates.
 @param coordinates The collection of coordinates.
 @param count The number of coordinates.
 @return Returns an WRLDCoordinateBounds instance for the region.
 */
WRLDCoordinateBounds WRLDCoordinateBoundsFromCoordinatesMake(CLLocationCoordinate2D* coordinates, NSUInteger count);
