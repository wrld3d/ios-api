#pragma once

#import "WRLDIndoorEntityHighlight.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDIndoorEntityHighlight;

@interface WRLDIndoorEntityHighlight (Private)

- (instancetype)initWithId:(NSString*)indoorEntityId
               indoorMapId:(NSString*)indoorMapId
                     color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
