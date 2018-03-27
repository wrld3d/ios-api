#import "WRLDSearchRequest.h"
#import "WRLDSearchRequest+Private.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchQuery+Private.h"
#import "WRLDSearchRequestFulfillerHandle.h"

@implementation WRLDSearchRequest
{
    id<WRLDSearchRequestFulfillerHandle> m_fulfillerHandle;
    WRLDSearchQuery *m_query;
}

-(instancetype) initWithFulfillerHandle: (id<WRLDSearchRequestFulfillerHandle>) fulfillerHandle forQuery: (WRLDSearchQuery *) query
{
    self = [super init];
    if(self)
    {
        m_fulfillerHandle = fulfillerHandle;
        m_query = query;
        _hasCompleted = false;
    }
    return self;
}

- (NSString *) queryString {
    return m_query.queryString;
}

- (id<NSObject>) queryContext {
    return m_query.queryContext;
}

- (void) didComplete: (BOOL)success withResults: (WRLDSearchResultsCollection *) results {
    _hasCompleted = true;
    [m_query addResults: results fromFulfiller: m_fulfillerHandle withSuccess: success];
}

- (void) cancel
{
    _hasCompleted = true;
    [m_query cancelRequest: self];
}

@end

