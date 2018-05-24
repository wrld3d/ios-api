#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDPointOnRouteOptions;

@interface WRLDPointOnRouteOptions (Private)
- (instancetype)init:(NSString*)indoorMapId
    indoorMapFloorId:(NSInteger)indoorMapFloorId;

@end

NS_ASSUME_NONNULL_END
