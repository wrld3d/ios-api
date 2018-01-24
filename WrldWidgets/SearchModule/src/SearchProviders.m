#import "SearchProviders.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchResultSet.h"

@implementation SearchProviders
{
    NSMutableArray<id<WRLDSearchProvider> >*m_searchProviders;
}

-(instancetype) init
{
    self = [super init];
    if(self){
        m_searchProviders = [ [NSMutableArray<id<WRLDSearchProvider> > alloc ]init];
    }
    return self;
}

-(WRLDSearchResultSet *) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    [m_searchProviders addObject: searchProvider];
    WRLDSearchResultSet *resultsSet = [[WRLDSearchResultSet alloc] init];
    [searchProvider setSearchProviderDelegate: resultsSet];
    return resultsSet;
}

-(void) doSearch: (NSString*) query {
    for(id<WRLDSearchProvider> provider in m_searchProviders){
        [provider search: query];
    }
}

-(NSString *) getCellIdentifierForSetAtIndex:(NSInteger) index {
    return m_searchProviders[index].cellIdentifier;
}

-(CGFloat) getCellExpectedHeightForSetAtIndex:(NSInteger) index {
    return m_searchProviders[index].cellExpectedHeight;
}

@end

