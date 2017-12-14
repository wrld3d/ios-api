#import "WRLDRoutingQueryResponse.h"
#import "WRLDRoutingQueryResponse+Private.h"

@interface WRLDRoutingQueryResponse ()

@end

@implementation WRLDRoutingQueryResponse
{
    BOOL m_succeeded;
    NSMutableArray* m_results;
}

- (instancetype)initWithStatusAndResults:(bool)succeeded results:(NSMutableArray*)results
{
    if (self = [super init])
    {
        m_succeeded = succeeded;
        m_results = results;
    }

    return self;
}

- (BOOL)succeeded
{
    return m_succeeded;
}

- (NSMutableArray *)results
{
    return m_results;
}

@end
