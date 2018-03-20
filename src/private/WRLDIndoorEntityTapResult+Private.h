#import "WRLDIndoorEntityTapResult.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDIndoorEntityTapResult;

@interface WRLDIndoorEntityTapResult (Private)

- (instancetype) initWithScreenPoint:(CGPoint)screenPoint
                         indoorMapId:(NSString*)indoorMapId
                     indoorEntityIds:(NSArray<NSString*>*)indoorEntityIds;

@end

NS_ASSUME_NONNULL_END
