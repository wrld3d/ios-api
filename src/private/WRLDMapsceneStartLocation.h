#pragma once

#include <CoreLocation/CoreLocation.h>
#include <Foundation/Foundation.h>


@interface WRLDMapsceneStartLocation : NSObject

-(CLLocationCoordinate2D)getCoordinate;
-(CLLocationDistance)getDistance;
-(int)getInteriorFloorIndex;
-(NSString*)getInteriorId;
-(double)getHeading;
-(bool)getTryStartAtGpsLocation;

-(void)setCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)setDistance:(CLLocationDistance)distance;
-(void)setInteriorFloorIndex:(int)interiorFloorIndex;
-(void)setInteriorId:(NSString*)interiorId;
-(void)setHeading:(double)heading;
-(void)setTryStartAtGpsLocation:(bool)tryStartAtGpsLocation;

@end

