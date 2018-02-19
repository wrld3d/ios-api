#import "WRLDSearchWidgetResultSetViewModel.h"
#import "WRLDSearchResultModel.h"
#import "WRLDSearchTypes.h"
#import "WRLDSearchRequestFulfillerHandle.h"

@implementation WRLDSearchWidgetResultSetViewModel
{
    WRLDSearchResultsCollection * m_results;
    NSInteger m_visibleResultsWhenCollapsed;
    NSInteger m_maxToShowWhenCollapsed;
    NSInteger m_maxToShowWhenExpanded;
}

- (instancetype) initForRequestFulfiller: (id<WRLDSearchRequestFulfillerHandle>) requestFulfillerHandle
                        maxToShowWhenCollapsed: (NSInteger) maxToShowWhenCollapsed
                         maxToShowWhenExpanded: (NSInteger) maxToShoWhenExpanded
{
    self = [super init];
    if(self)
    {
        _fulfiller = requestFulfillerHandle;
        
        _expandedState = Collapsed;
        m_maxToShowWhenCollapsed = maxToShowWhenCollapsed;
        m_maxToShowWhenExpanded = maxToShoWhenExpanded;
    }
    return self;
}

- (void) updateResultData:(WRLDSearchResultsCollection *) results
{
    m_results = results;
    [self setExpandedState: Collapsed];
}

- (id<WRLDSearchResultModel>) getResult:(NSInteger)index
{
    return [m_results objectAtIndex:index];
}

- (void) setExpandedState: (ExpandedStateType) state {
    _expandedState = state;
}

- (BOOL) hasMoreResultsCellWhen: (ExpandedStateType) state
{
    if( state == Collapsed )
    {
        return [self getVisibleResultCountWhen: Collapsed] < [self getResultCount];
    }
    else if (state == Expanded)
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(CGFloat) getResultsCellHeightWhen : (ExpandedStateType) state
{
    CGFloat visibleCellHeight = [self getVisibleResultCountWhen : state] * self.fulfiller.cellHeight;
    
    return visibleCellHeight;
}

- (NSInteger) getVisibleResultCountWhen : (ExpandedStateType) state
{
    if(state == Hidden){
        return 0;
    }
    else if(state == Collapsed){
        return MIN(m_maxToShowWhenCollapsed, [self getResultCount]);
    }
    else{
        return [self getResultCount];
    }
}

- (NSInteger) getResultCount
{
    return MIN(m_maxToShowWhenExpanded, [m_results count]);
}

- (BOOL) isMoreResultsCell: (NSInteger)row
{
    return [self hasMoreResultsCellWhen: self.expandedState] && row == [self getVisibleResultCountWhen: self.expandedState];
}

@end
