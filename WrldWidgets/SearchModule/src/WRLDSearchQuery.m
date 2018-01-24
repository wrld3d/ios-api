
#import "WRLDSearchQuery.h"
#import "WRLDSearchProvider.h"

@implementation WRLDSearchQuery
{
    id<WRLDSearchQueryCompleteDelegate> m_onCompletion;
    NSMutableArray <WRLDSearchResult *> *m_allResults;
    NSMutableArray <id<WRLDSearchProvider>> *m_completedProviders;
    NSInteger m_providersQueriedCount;
}

-(instancetype) initWithQueryString:(NSString *)queryString :(NSInteger) providersQueriedCount
{
    self = [super init];
    if(self)
    {
        _queryString = queryString;
        m_providersQueriedCount = providersQueriedCount;
    }
    return self;
}

-(void) setCompletionDelegate:(id<WRLDSearchQueryCompleteDelegate>)delegate
{
    m_onCompletion = delegate;
}

-(void) updateResults:(id<WRLDSearchProvider>)provider :(WRLDSearchResult *)results
{
    
}

@end
