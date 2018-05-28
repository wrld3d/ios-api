#import "WRLDPrecacheOperationResult.h"
#import "WRLDPrecacheOperationResult+Private.h"

@interface WRLDPrecacheOperationResult ()

@end

@implementation WRLDPrecacheOperationResult
{
    BOOL m_succeeded;
}

- (instancetype)initWithStatus:(bool)succeeded
{
    if (self = [super init])
    {
        m_succeeded = succeeded;
    }

    return self;
}

- (BOOL)succeeded
{
    return m_succeeded;
}

@end
