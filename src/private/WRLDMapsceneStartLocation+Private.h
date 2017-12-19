#pragma once

#include <CoreLocation/CoreLocation.h>
#include <Foundation/Foundation.h>

#import "WRLDMapsceneStartLocation.h"

@class WRLDMapsceneStartLocation;

@interface WRLDMapsceneStartLocation(Private)


-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate distance:(CLLocationDistance)distance interiorFloorIndex:(int)interiorFloorIndex interiorId:(NSString*)interiorId heading:(double)heading tryStartAtGpsLocation:(bool)tryStartAtGpsLocation;



@end

