#pragma once

#import <Foundation/Foundation.h>

#include "WRLDPointOnRouteResult.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDPointOnRouteResult;

@interface WRLDPointOnRouteResult (Private)

- (instancetype)initWithResultPoint:(CLLocationCoordinate2D)resultPoint
                         inputPoint:(CLLocationCoordinate2D)inputPoint
             distanceFromInputPoint:(double)distanceFromInputPoint
                 fractionAlongRoute:(double)fractionAlongRoute
          fractionAlongRouteSection:(double)fractionAlongRouteSection
             fractionAlongRouteStep:(double)fractionAlongRouteStep
                          routeStep:(WRLDRouteStep*)routeStep
                       routeSection:(WRLDRouteSection*)routeSection
        routeSectionIndex:(int)routeSectionIndex
        routeStepIndex:(int)routeStepIndex
        pathSegmentStartVertexIndex:(int)pathSegmentStartVertexIndex;

@end

NS_ASSUME_NONNULL_END
