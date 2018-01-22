
#import "WRLDSearchProvider.h"

@implementation WRLDSearchProviderBase
{
    id<WRLDSearchProviderDelegate> m_searchProviderDelegate;
}

- (void) setSearchProviderDelegate: (id<WRLDSearchProviderDelegate>) searchProviderDelegate
{
    m_searchProviderDelegate = searchProviderDelegate;
}

-(void) addResults: (NSMutableArray<WRLDSearchResult*>*) searchResults
{
    if(m_searchProviderDelegate != nil)
        [m_searchProviderDelegate addResults:searchResults];
}

-(void) clearResults
{
    if(m_searchProviderDelegate != nil)
        [m_searchProviderDelegate clearResults];
}

@end
