#import "WRLDIndoorEntityTapResult.h"
#import "WRLDIndoorEntityTapResult+Private.h"

@interface WRLDIndoorEntityTapResult ()

@end

@implementation WRLDIndoorEntityTapResult
{
}

- (instancetype) initWithScreenPoint:(CGPoint)screenPoint
                         indoorMapId:(NSString*)indoorMapId
                     indoorEntityIds:(NSArray<NSString*>*)indoorEntityIds
{
    if (self = [super init])
    {
        _screenPoint = screenPoint;
        _indoorMapId = indoorMapId;
        _indoorEntityIds = indoorEntityIds;
    }
    
    return self;
}

@end
