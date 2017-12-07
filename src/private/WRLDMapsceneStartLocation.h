#pragma once

#include <CoreLocation/CoreLocation.h>
#include <Foundation/Foundation.h>


@interface WRLDMapsceneStartLocation : NSObject

-(instancetype) initWRLDMapsceneStartLocationMake:(CLLocationCoordinate2D)coordinate :(CLLocationDistance)altitude :(int)interiorFloorIndex :(double)heading :(bool)tryStartAtGpsLocation;

-(CLLocationCoordinate2D)getCoordinate;
-(CLLocationDistance)getAltitude;
-(int)getInteriorFloorIndex;
-(double)getHeading;
-(bool)getTryStartAtGpsLocation;

@end

