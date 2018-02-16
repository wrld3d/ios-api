#import "WRLDSearchWidgetTableViewController.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchTypes.h"
#import "WRLDSearchWidgetResultSetViewModel.h"
#import "WRLDSearchRequestFulfillerHandle.h"
#import "WRLDSearchResultTableViewCell.h"

typedef NSMutableArray<WRLDSearchWidgetResultSetViewModel *> ResultSetViewModelCollection;

@implementation WRLDSearchWidgetTableViewController
{
    UITableView * m_tableView;
    UIView * m_visibilityView;
    NSLayoutConstraint * m_heightConstraint;
    ResultSetViewModelCollection * m_providerViewModels;
    NSString * m_defaultCellIdentifier;
    WRLDSearchQuery *m_displayedQuery;
    CGFloat m_fadeDuration;
    
    CGFloat m_searchInProgressCellHeight;
    CGFloat m_headerCellHeight;
    CGFloat m_footerCellHeight;
    CGFloat m_maxTableHeight;
    
    bool m_isAnimatingOut;
}

- (instancetype) initWithTableView: (UITableView *) tableView
                    visibilityView: (UIView*) visibilityView
                  heightConstraint: (NSLayoutConstraint *) heightConstraint
             defaultCellIdentifier: (NSString *) defaultCellIdentifier
{
    self = [super init];
    if(self)
    {
        m_tableView = tableView;
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_visibilityView = visibilityView;
        m_heightConstraint = heightConstraint;
        m_providerViewModels = [[ResultSetViewModelCollection alloc] init];
        m_isAnimatingOut = false;
        m_defaultCellIdentifier = defaultCellIdentifier;
        m_fadeDuration = 1.0f;
        
        m_searchInProgressCellHeight = 48;
        // Assigning these values to 0 causes the table to use the default values for header(32) and footer(8)) so use CGFLOAT_MIN
        [self setHeaderHeight: CGFLOAT_MIN];
        [self setFooterHeight: CGFLOAT_MIN];
        m_maxTableHeight = 400;
    }
    
    return self;
}

- (void) setHeaderHeight: (CGFloat) height
{
    m_headerCellHeight = height;
    m_tableView.sectionHeaderHeight = height;
}

- (void) setFooterHeight: (CGFloat) height
{
    m_footerCellHeight = height;
    m_tableView.sectionFooterHeight = height;
}

- (void) showQuery: (WRLDSearchQuery *) sourceQuery
{
    m_displayedQuery = sourceQuery;
    for(WRLDSearchWidgetResultSetViewModel *set in m_providerViewModels)
    {
        [set updateResultData:[sourceQuery getResultsForFulfiller: set.fulfillerId]];
    }
    [self resizeTable];
    [m_tableView reloadData];
}

- (void) displayResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider
{
    WRLDSearchWidgetResultSetViewModel * newProviderViewModel = [[WRLDSearchWidgetResultSetViewModel alloc] initForRequestFulfiller: provider];
    [m_providerViewModels addObject: newProviderViewModel];
    [m_tableView reloadData];
}

- (void) stopDisplayingResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider
{
    [m_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:m_defaultCellIdentifier];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!m_displayedQuery || ! m_displayedQuery.hasCompleted ){
        return 0;
    }
    
    return [m_providerViewModels count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WRLDSearchWidgetResultSetViewModel * providerViewModel = [m_providerViewModels objectAtIndex:section];
    return [providerViewModel getVisibleResultCount];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(WRLDSearchResultTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDSearchWidgetResultSetViewModel *sectionViewModel = [m_providerViewModels objectAtIndex:[indexPath section]];
    id<WRLDSearchResultModel> resultModel = [sectionViewModel getResult : [indexPath row]];
    [cell populateWith: resultModel highlighting: m_displayedQuery.queryString];
}

- (void) resizeTable
{
    CGFloat height = 0;
    if([m_displayedQuery progress] == InFlight)
    {
        height = m_searchInProgressCellHeight;
    }
    else
    {
        for(int i = 0; i < [m_providerViewModels count]; ++i)
        {
            height += [self getHeightForSet: i];
        }
        height = MIN(m_maxTableHeight, height);
    }
    
    [UIView animateWithDuration: m_fadeDuration animations:^{
        m_heightConstraint.constant = height;
        [m_visibilityView layoutIfNeeded];
    }];
}

- (void) show
{
    [UIView animateWithDuration: m_fadeDuration animations:^{
        m_visibilityView.alpha = 1.0;
    }];
    m_visibilityView.hidden = NO;
}

- (void) hide
{
    if(!m_isAnimatingOut)
    {
        m_isAnimatingOut = true;
        [UIView animateWithDuration: m_fadeDuration animations:^{
            m_visibilityView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if(finished){
                m_visibilityView.hidden =  YES;
                m_isAnimatingOut = false;
            }
        }];
    }
}

-(CGFloat) getHeightForSet : (NSInteger) setIndex
{
    CGFloat headerHeight = [self tableView:m_tableView heightForHeaderInSection:setIndex];
    CGFloat footerHeight = [self tableView:m_tableView heightForFooterInSection:setIndex];
    
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: setIndex];
    
    CGFloat contentHeight = [setViewModel getVisibleResultCount] * setViewModel.expectedCellHeight;
    
    return headerHeight + contentHeight + footerHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: section];
    if ([setViewModel getVisibleResultCount] > 0)
    {
        return m_headerCellHeight;
    }
    // returning 0 causes the table to use the default value (32)
    return CGFLOAT_MIN;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: section];
    if ([setViewModel hasMoreToShow])
    {
        return m_footerCellHeight;
    }
    // returning 0 causes the table to use the default value (8)
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: [indexPath section]];
    return setViewModel.expectedCellHeight;
}

@end
