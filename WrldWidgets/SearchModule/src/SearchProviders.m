#import "SearchProviders.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchResultSet.h"

@implementation SearchProviders
{
    id<WRLDSearchProvider> m_searchProvider;
    WRLDSearchResultSet* m_searchResult;
}

-(WRLDSearchResultSet *) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    m_searchProvider = searchProvider;
    m_searchResult = [[WRLDSearchResultSet alloc] init];
    [searchProvider setSearchProviderDelegate: m_searchResult];
    return m_searchResult;
}

-(void) doSearch: (NSString*) query {
    [m_searchProvider search: query];
}

@end

