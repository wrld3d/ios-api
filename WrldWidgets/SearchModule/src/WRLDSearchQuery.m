
#import "WRLDSearchQuery.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchResultSet.h"
#import "SearchProviders.h"

@implementation WRLDSearchQuery
{
    id<WRLDSearchQueryCompleteDelegate> m_onCompletion;
    NSMutableArray <WRLDSearchResultSet *> *m_allResults;
    SearchProviders *m_searchProviders;
    NSInteger m_providerCompletedCount;
}

-(instancetype) initWithQueryString:(NSString *)queryString :(SearchProviders*) providers
{
    self = [super init];
    if(self)
    {
        _queryString = queryString;
        m_searchProviders = providers;
        m_allResults = [[NSMutableArray <WRLDSearchResultSet *> alloc]init];
        for(NSInteger i = 0; i < [providers count]; ++i)
        {
            [m_allResults addObject:[[WRLDSearchResultSet alloc]init]];
        }
        _progress = InFlight;
    }
    return self;
}

-(void) setCompletionDelegate:(id<WRLDSearchQueryCompleteDelegate>)delegate
{
    m_onCompletion = delegate;
}

-(void) addResults:(id<WRLDSearchProvider>)provider :(NSMutableArray<WRLDSearchResult*>*)results
{
    if(_progress == InFlight)
    {
        NSInteger providerIndex = [m_searchProviders getIndexOfProvider:provider];
        if(providerIndex == NSNotFound)
        {
            return;
        }
        if([m_allResults[providerIndex] hasReceivedResults])
        {
            return;
        }
        [m_allResults[providerIndex] addResults:results];
        ++m_providerCompletedCount;
        if(m_providerCompletedCount == [m_searchProviders count])
        {
            _progress = Completed;
            if(m_onCompletion)
            {
                [m_onCompletion updateResults];
            }
        }
    }
}

-(WRLDSearchResultSet *) getResultSetForProviderAtIndex: (NSInteger) index
{
    return m_allResults[index];
}

-(void) cancel
{
    _progress = Cancelled;
}

@end
