#import "SearchProviders.h"
#import "WRLDSearchProvider.h"

@implementation SearchProviders
{
    id<WRLDSearchProvider> m_searchProvider;
}

-(void) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    m_searchProvider = searchProvider;
}

-(void) doSearch: (NSString*) query {
    [m_searchProvider search: query];
}

@end

