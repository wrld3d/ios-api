#import "SearchProviders.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchQuery.h"
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

-(void) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    [m_searchProviders addObject: searchProvider];
}

-(void) doSearch: (WRLDSearchQuery *) query {
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

-(NSInteger) count
{
    return [m_searchProviders count];
}

-(NSInteger) getIndexOfProvider:(id<WRLDSearchProvider>)provider {
    return [m_searchProviders indexOfObject:provider];
}

@end

