#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDRoutingQueryResponse;

@interface WRLDRoutingQueryResponse (Private)

- (instancetype)initWithStatusAndResults:(bool)succeeded
                                 results:(NSMutableArray*)results;

@end

NS_ASSUME_NONNULL_END
