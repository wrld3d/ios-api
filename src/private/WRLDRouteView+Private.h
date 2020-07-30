#pragma once

#include "WRLDMapView+Private.h"
#include "WRLDRoute+Private.h"
#include "WRLDRouteViewOptions.h"

//NS_ASSUME_NONNULL_BEGIN

@class WRLDRouteView;

@interface WRLDRouteView (Private)

- (instancetype)initWithMapView:(WRLDMapView*)map
                          route:(WRLDRoute*)route
                         option:(WRLDRouteViewOptions*)options;

-(void) addLinesForRoutePath:(CLLocationCoordinate2D*)path pathCount:(int) count ofColor:(UIColor*)color;

-(void) addLinesForRoutePath:(CLLocationCoordinate2D*)path pathCount:(int)count ofColor:(UIColor*)color indoorId:(NSString*)indoorId floorId:(int)floorId;

-(void) addLinesForRouteStep:(WRLDRouteStep*)step
         closestPointOnPath:(CLLocationCoordinate2D) closestPoint
                  splitIndex:(int) sIndex;
@end

//NS_ASSUME_NONNULL_END
