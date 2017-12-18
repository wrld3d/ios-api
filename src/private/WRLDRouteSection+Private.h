#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDRouteSection;

@interface WRLDRouteSection (Private)

- (instancetype)initWithSteps:(NSMutableArray*)steps
                     duration:(NSTimeInterval)duration
                     distance:(CLLocationDistance)distance;

@end

NS_ASSUME_NONNULL_END
