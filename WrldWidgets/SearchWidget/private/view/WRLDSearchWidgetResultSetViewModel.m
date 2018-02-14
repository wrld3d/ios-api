#import "WRLDSearchWidgetResultSetViewModel.h"
#import "WRLDSearchResultModel.h"
#import "WRLDSearchTypes.h"

@implementation WRLDSearchWidgetResultSetViewModel
{
    WRLDSearchResultsCollection * m_results;
    NSInteger m_visibleResultsWhenCollapsed;
}

- (instancetype) initForRequestFulfiller: (NSInteger) requestFulfillerId;
{
    self = [super init];
    if(self)
    {
        _fulfillerId = requestFulfillerId;
        _expandedState = Collapsed;
        m_visibleResultsWhenCollapsed = 3;
    }
    return self;
}

- (void) updateResultData:(WRLDSearchResultsCollection *) results
{
    m_results = results;
    _totalResultCount = [results count];
}

- (id<WRLDSearchResultModel>) getResult:(NSInteger)index
{
    return [m_results objectAtIndex:index];
}

- (NSInteger) getVisibleResultCount
{
    if(self.expandedState == Hidden){
        return 0;
    }
    else if(self.expandedState == Collapsed){
        return MIN(m_visibleResultsWhenCollapsed, self.totalResultCount);
    }
    else{
        return self.totalResultCount;
    }
}

@end
