#import "WRLDRoutingQuery.h"
#import "WRLDRoutingQuery+Private.h"

@interface WRLDRoutingQuery ()

@end

@implementation WRLDRoutingQuery
{
    Eegeo::Api::EegeoRoutingApi* m_routingApi;
    int m_queryId;
}

- (instancetype)initWithIdAndApi:(int)queryId routingApi:(Eegeo::Api::EegeoRoutingApi&)routingApi
{
    if (self = [super init])
    {
        m_routingApi = &routingApi;
        m_queryId = queryId;
    }

    return self;
}

- (void)cancel
{
    m_routingApi->CancelQuery(m_queryId);
}

- (int)routingQueryId
{
    return m_queryId;
}

@end
