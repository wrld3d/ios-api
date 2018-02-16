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
        _fulfillerId = requestFulfillerHandle.identifier;
        _expectedCellHeight = requestFulfillerHandle.cellHeight;
        _cellIdentifier = requestFulfillerHandle.cellIdentifier;
        _moreResultsName = requestFulfillerHandle.moreResultsName;
        
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
    [self setHasMoreToShowFlag];
}

- (void) setHasMoreToShowFlag
{
    if( self.expandedState == Collapsed )
    {
        _hasMoreToShow = [self getVisibleResultCount] < [self getResultCount];
    }
    else
    {
        _hasMoreToShow = false;
    }
}

- (NSInteger) getVisibleResultCount
{
    if(self.expandedState == Hidden){
        return 0;
    }
    else if(self.expandedState == Collapsed){
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
    return _hasMoreToShow && row == [self getVisibleResultCount];
}

@end
