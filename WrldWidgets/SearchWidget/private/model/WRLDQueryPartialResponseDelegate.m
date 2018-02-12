#import "WRLDQueryPartialResponseDelegate.h"
#import "WRLDMultipleProviderQuery.h"
#import "WRLDQueryFulfillerHandle.h"

@implementation WRLDQueryPartialResponseDelegate
{
    id<WRLDQueryFulfillerHandle> m_fulfillerHandle;
    WRLDMultipleProviderQuery *m_fullQuery;
}

-(instancetype) initWithFulfillerHandle: (id<WRLDQueryFulfillerHandle>) fulfillerHandle forFullQuery:(WRLDMultipleProviderQuery *) query
{
    self = [super init];
    if(self)
    {
        m_fulfillerHandle = fulfillerHandle;
        m_fullQuery = query;
    }
    return self;
}

- (void)didComplete:(BOOL)success withResults:(WRLDSearchResultsCollection *)results {
    [m_fullQuery addResults: results fromFulfiller: m_fulfillerHandle withSuccess: success];
}

@end

