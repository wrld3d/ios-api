#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDRoute;

@interface WRLDRoute (Private)

- (instancetype)initWithSections:(NSMutableArray*)sections
                        duration:(NSTimeInterval)duration
                        distance:(double)distance;

@end

NS_ASSUME_NONNULL_END
