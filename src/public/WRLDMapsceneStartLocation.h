#pragma once

#include <CoreLocation/CoreLocation.h>
#include <Foundation/Foundation.h>


@interface WRLDMapsceneStartLocation : NSObject

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,readonly) CLLocationDistance distance;
@property (nonatomic,readonly) int interiorFloorIndex;
@property (nonatomic,readonly) NSString* interiorId;
@property (nonatomic,readonly) double heading;
@property (nonatomic,readonly) bool tryStartAtGpsLocation;


@end

