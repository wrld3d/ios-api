// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EGShape.h"
#import <CoreLocation/CLLocation.h>

/*!
 @class EGPointAnnotation
 @brief Defines a concrete annotation object located at a specified point. 
 @discussion You can use this class, rather than define your own, in situations where all you want to do is associate a point on the map with a title.
 */
@interface EGPointAnnotation : EGShape

/*!
 @property coordinate
 @brief The coordinate point of the annotation, specified as a WGS84 latitude and longitude.
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
