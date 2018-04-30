#import "WRLDPrecacheOperation.h"
#import "WRLDPrecacheOperation+Private.h"

@interface WRLDPrecacheOperation ()

@end

@implementation WRLDPrecacheOperation
{
    Eegeo::Api::EegeoPrecacheApi* m_precacheApi;
    int m_operationId;
    WRLDPrecacheOperationHandler m_completionHandler;
}

- (instancetype)initWithId:(int)operationId precacheApi:(Eegeo::Api::EegeoPrecacheApi&)precacheApi completionHandler:(WRLDPrecacheOperationHandler)completionHandler
{
    if (self = [super init])
    {
        m_precacheApi = &precacheApi;
        m_operationId = operationId;
        m_completionHandler = completionHandler;
    }

    return self;
}

- (void)completeWithResult:(WRLDPrecacheOperationResult*)response
{
    if (m_completionHandler)
    {
        m_completionHandler(response);
    }
}

- (void)cancel
{
    m_precacheApi->CancelPrecacheOperation(m_operationId);
}

- (int)precacheOperationId
{
    return m_operationId;
}

@end
