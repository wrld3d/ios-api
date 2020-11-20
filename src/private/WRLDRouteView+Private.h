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

- (void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep
                          stepBefore:(WRLDRouteStep*)routeStepBefore
                           stepAfter:(WRLDRouteStep*)routeStepAfter
                  flattenedStepIndex:(int)flattenStepIndex
                               color:(UIColor*)color;

- (void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep
                    flattenStepIndex:(int)flattenStepIndex;

- (void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep
                           stepIndex:(int)stepIndex
                  closestPointOnPath:(CLLocationCoordinate2D)closestPointOnPath
                          splitIndex:(int)splitIndex
@end

//NS_ASSUME_NONNULL_END
