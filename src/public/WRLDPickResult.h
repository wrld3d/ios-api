#pragma once

#import <Foundation/Foundation.h>

#import "WRLDMapFeatureType.h"
#import "WRLDCoordinateWithAltitude.h"
#import "WRLDVector3.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Result values returned by WRLDMap picking api methods.
 */
@interface WRLDPickResult : NSObject

/*!
 True if the picking ray intersected with a map feature, else false.
 */
@property (nonatomic, readonly) Boolean found;

/*!
 The type of map feature intersected with, if any.
 */
@property (nonatomic, readonly) WRLDMapFeatureType mapFeatureType;

/*!
 The location of intersection, if any.
 */
@property (nonatomic, readonly) WRLDCoordinateWithAltitude intersectionPoint;

/*!
 The surface normal of the map feature intersected with, if any, in ECEF coordinates.
 */
@property (nonatomic, readonly) WRLDVector3 intersectionSurfaceNormal;

@end

NS_ASSUME_NONNULL_END
