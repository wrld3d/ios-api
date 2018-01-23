#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDRouteViewOptions;

@interface WRLDRouteViewOptions (Private)

- (instancetype)init:(CGFloat)width
               color:(UIColor*)color
          miterLimit:(CGFloat)miterLimit;

@end

NS_ASSUME_NONNULL_END
