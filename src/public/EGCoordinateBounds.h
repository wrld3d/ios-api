// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <CoreLocation/CoreLocation.h>


/*!
 @struct EGCoordinateBounds
 @brief Contains the WGS84 extents of a bounded region of the map.
 */
typedef struct {
    CLLocationCoordinate2D sw;
    CLLocationCoordinate2D ne;
} EGCoordinateBounds;

/*!
 @function EGCoordinateBoundsMake
 @brief Create an EGCoordinateBounds instance from a pair of WGS84 coordinates.
 @param sw The south western point.
 @param ne The north eastern point.
 @return Returns an EGCoordinateBounds instance for the region.
 */
EGCoordinateBounds EGCoordinateBoundsMake(CLLocationCoordinate2D sw,
                                          CLLocationCoordinate2D ne);

/*!
 @function EGCoordinateBoundsMake
 @brief Create an EGCoordinateBounds instance from a collection of WGS84 coordinates.
 @param coordinates The collection of coordinates.
 @param count The number of coordinates.
 @return Returns an EGCoordinateBounds instance for the region.
 */
EGCoordinateBounds EGCoordinateBoundsFromCoordinatesMake(CLLocationCoordinate2D* coordinates,
                                                         NSUInteger count);

