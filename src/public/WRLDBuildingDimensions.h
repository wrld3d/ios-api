#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Represents dimensional information about a building on the map.
 */
@interface WRLDBuildingDimensions : NSObject

/*!
 The altitude of the building’s baseline - nominally at local ground level.
 */
@property (nonatomic, readonly) CLLocationDistance baseAltitude;

/*!
 The altitude of the building’s highest point.
 */
@property (nonatomic, readonly) CLLocationDistance topAltitude;

/*!
 The centroid of the building in plan view.
 */
@property (nonatomic, readonly) CLLocationCoordinate2D centroid;

@end

NS_ASSUME_NONNULL_END
