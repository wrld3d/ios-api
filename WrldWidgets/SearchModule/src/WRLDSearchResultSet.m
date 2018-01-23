#import <Foundation/Foundation.h>
#import "WRLDSearchResultSet.h"
#import "WRLDSearchResultsArrivedDelegate.h"

@implementation WRLDSearchResultSet
{
    NSMutableArray<WRLDSearchResult*>* m_results;
    id<WRLDSearchResultsArrivedDelegate> m_updateDelegate;
}

- (instancetype) init
{
    [super self];
    if(self){
        m_results = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSMutableArray<WRLDSearchResult*>*)getAllResults
{
    return m_results;
}

- (void)addResults:(NSMutableArray<WRLDSearchResult*>*)searchResults{
    [m_results addObjectsFromArray: searchResults];
    [m_updateDelegate updateResults];
}

-(void) clearResults
{
    [m_results removeAllObjects];
}

- (NSInteger) getResultCount
{
    return m_results.count;
}

- (WRLDSearchResult*) getResult:(NSInteger) index
{
    if(index < m_results.count)
    {
        return m_results[index];
    }
    return nil;
}

- (void) updateDelegate :(id<WRLDSearchResultsArrivedDelegate>) delegate
{
    m_updateDelegate = delegate;
}

@end
