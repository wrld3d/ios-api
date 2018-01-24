#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Represents dimensional information about a building on the map.
 */
@interface WRLDBuildingDimensions : NSObject

/*!
 @returns The altitude of the building’s baseline - nominally at local ground level.
 */
- (CLLocationDistance) baseAltitude;

/*!
 @returns The altitude of the building’s highest point.
 */
- (CLLocationDistance) topAltitude;

/*!
 @returns The centroid of the building in plan view.
 */
- (CLLocationCoordinate2D) centroid;

@end

NS_ASSUME_NONNULL_END
