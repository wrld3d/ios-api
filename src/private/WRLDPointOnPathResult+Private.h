#pragma once

#import <Foundation/Foundation.h>

#include "WRLDPointOnPathResult.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDPointOnPathResult;

@interface WRLDPointOnPathResult (Private)

- (instancetype)initWithResultPoint:(CLLocationCoordinate2D)resultPoint
                         inputPoint:(CLLocationCoordinate2D)inputPoint
             distanceFromInputPoint:(double)distanceFromInputPoint
                  fractionAlongPath:(double)fractionAlongPath
      indexOfPathSegmentStartVertex:(int)indexOfPathSegmentStartVertex
        indexOfPathSegmentEndVertex:(int)indexOfPathSegmentEndVertex;

@end

NS_ASSUME_NONNULL_END
