// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EGShape.h"
#import <CoreLocation/CLLocation.h>

@interface EGPointAnnotation : EGShape

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
