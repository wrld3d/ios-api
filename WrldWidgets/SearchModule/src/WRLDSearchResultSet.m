#import <Foundation/Foundation.h>
#import "WRLDSearchResultSet.h"

@implementation WRLDSearchResultSet
{    
    NSMutableArray<WRLDSearchResult*>* m_results;
    
    NSInteger m_maxVisibleResultsInCollapsedState;
    
    ExpandedStateType m_expandedState;
    
    bool m_hasReceivedResults;
}

- (instancetype) init
{
    [super self];
    if(self){
        m_results = [[NSMutableArray alloc] init];
        m_expandedState = Collapsed;
        m_maxVisibleResultsInCollapsedState = 3;
        m_hasReceivedResults = false;
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
    m_hasReceivedResults = true;
}

-(bool) hasReceivedResults
{
    return m_hasReceivedResults;
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
