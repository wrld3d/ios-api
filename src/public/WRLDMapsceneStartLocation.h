#pragma once

#include <CoreLocation/CoreLocation.h>
#include <Foundation/Foundation.h>

/**
 * The data for representing the start location of a Mapscene. Includes starting orientation and
 * optional Indoor Map configuration.
 */
@interface WRLDMapsceneStartLocation : NSObject

/**
 * The initial Latitude & Longitude of the starting camera's view.
 */
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;

/**
 * The initial distance between the camera's position and its focused interest position.
 */
@property (nonatomic,readonly) CLLocationDistance distance;

/**
 * An optional Floor Index to start in - Default is 0. Only applicable when setting an
 * Indoor Map id as well.
 */
@property (nonatomic,readonly) int interiorFloorIndex;

/**
 * An optional ID for an Indoor Map to start in - Default is blank/none.
 */
@property (nonatomic,readonly) NSString* interiorId;

/**
 * The initial heading in degrees, as an offset from north.
 */
@property (nonatomic,readonly) double heading;

/**
 * An optional flag to specify if you want to try starting the map at the Device's GPS
 * position.  Only currently applicable to mobile devices via the Wrld App.
 */
@property (nonatomic,readonly) bool tryStartAtGpsLocation;


@end

