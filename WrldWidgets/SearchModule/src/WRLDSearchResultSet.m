#import <Foundation/Foundation.h>
#import "WRLDSearchResultSet.h"
#import "WRLDSearchResultsArrivedDelegate.h"

@implementation WRLDSearchResultSet
{    
    NSMutableArray<WRLDSearchResult*>* m_results;
    id<WRLDSearchResultsArrivedDelegate> m_updateDelegate;
    
    NSInteger m_maxVisibleResultsInCollapsedState;
    
    ExpandedStateType m_expandedState;
}

- (instancetype) init
{
    [super self];
    if(self){
        m_results = [[NSMutableArray alloc] init];
        m_expandedState = Collapsed;
        m_maxVisibleResultsInCollapsedState = 3;
    }
    
    return self;
}

-(NSMutableArray<WRLDSearchResult*>*)getAllResults
{
    return m_results;
}

- (void)addResults:(NSMutableArray<WRLDSearchResult*>*)searchResults{
    [m_results addObjectsFromArray: searchResults];
    m_expandedState = Collapsed;
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

- (NSInteger) getVisibleResultCount
{
    if( m_expandedState == Collapsed){
        return MIN(m_results.count, m_maxVisibleResultsInCollapsedState);
    }
    if(m_expandedState == Hidden){
        return 0;
    }
    
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

-(void) setExpandedState:(NSInteger)state {
    m_expandedState = state;
}

-(bool) hasMoreToShow
{
    bool showingAllResultsInCollapsed = m_expandedState == Collapsed && ([self getVisibleResultCount] == [self getResultCount]);
    if(m_expandedState == Hidden || showingAllResultsInCollapsed)
    {
        return false;
    }
    return true;
}

-(ExpandedStateType) getExpandedState
{
    return m_expandedState;
}

@end
