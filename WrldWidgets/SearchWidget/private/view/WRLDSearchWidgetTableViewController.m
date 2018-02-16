#import "WRLDSearchWidgetTableViewController.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchTypes.h"
#import "WRLDSearchWidgetResultSetViewModel.h"
#import "WRLDSearchRequestFulfillerHandle.h"
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDMoreResultsTableViewCell.h"
#import "WRLDSearchInProgressTableViewCell.h"

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
    CGFloat m_moreResultsCellHeight;
    CGFloat m_maxTableHeight;
    
    NSString * m_moreResultsCellStyleIdentifier;
    NSString * m_searchInProgressCellStyleIdentifier;
    
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
        
        m_moreResultsCellStyleIdentifier = @"WRLDMoreResultsTableViewCell";
        m_searchInProgressCellStyleIdentifier = @"WRLDSearchInProgressTableViewCell";
        
        m_searchInProgressCellHeight = 48;
        m_moreResultsCellHeight = 32;
        
        m_maxTableHeight = 400;
        
        [self assignCellResourcesTo: m_tableView];
    }
    
    return self;
}

- (void) assignCellResourcesTo: (UITableView *) tableView
{
    NSBundle* resourceBundle = [NSBundle bundleForClass:[WRLDSearchResultTableViewCell class]];
    
    [tableView registerNib:[UINib nibWithNibName: m_defaultCellIdentifier bundle:resourceBundle]
                forCellReuseIdentifier: m_defaultCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:m_searchInProgressCellStyleIdentifier bundle: resourceBundle]
                          forCellReuseIdentifier: m_searchInProgressCellStyleIdentifier];
    [tableView registerNib:[UINib nibWithNibName:m_moreResultsCellStyleIdentifier bundle: resourceBundle]
                forCellReuseIdentifier: m_moreResultsCellStyleIdentifier];
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
     maxToShowWhenCollapsed: (NSInteger) maxToShowWhenCollapsed
      maxToShowWhenExpanded: (NSInteger) maxToShowWhenExpanded
{
    WRLDSearchWidgetResultSetViewModel * newProviderViewModel = [[WRLDSearchWidgetResultSetViewModel alloc]
                                                                 initForRequestFulfiller: provider
                                                                 maxToShowWhenCollapsed: maxToShowWhenCollapsed
                                                                 maxToShowWhenExpanded: maxToShowWhenExpanded];
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
    NSString *expectedCellIdentifier =[self getIdentifierForCellAtPosition: indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: expectedCellIdentifier];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: m_defaultCellIdentifier];
    }
    return cell;
}

-(NSString *) getIdentifierForCellAtPosition:(NSIndexPath *) index
{
    if(!m_displayedQuery.hasCompleted){
        return m_searchInProgressCellStyleIdentifier;
    }
    
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: [index section]];
    
    if([setViewModel isMoreResultsCell: [index row]]){
        return m_moreResultsCellStyleIdentifier;
    }
    
    return setViewModel.cellIdentifier == nil ? m_defaultCellIdentifier : setViewModel.cellIdentifier;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!m_displayedQuery.hasCompleted){
        return 1;
    }
    
    return [m_providerViewModels count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(!m_displayedQuery.hasCompleted){
        return 1;
    }
    
    WRLDSearchWidgetResultSetViewModel * providerViewModel = [m_providerViewModels objectAtIndex:section];
    NSInteger cellsToDisplay = [providerViewModel getVisibleResultCount];
    if([providerViewModel hasMoreToShow])
    {
        ++cellsToDisplay;
    }
    return cellsToDisplay;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!m_displayedQuery.hasCompleted)
    {
        return;
    }
    
    WRLDSearchWidgetResultSetViewModel *sectionViewModel = [m_providerViewModels objectAtIndex:[indexPath section]];
    if([sectionViewModel isMoreResultsCell: [indexPath row]])
    {
        WRLDMoreResultsTableViewCell * moreResultsCell = (WRLDMoreResultsTableViewCell *) cell;
        [moreResultsCell populateWith: sectionViewModel];
        return;
    }
    
    id<WRLDSearchResultModel> resultModel = [sectionViewModel getResult : [indexPath row]];
    WRLDSearchResultTableViewCell * resultCell = (WRLDSearchResultTableViewCell *) cell;
    [resultCell populateWith: resultModel highlighting: m_displayedQuery.queryString];
}

- (void) resizeTable
{
    CGFloat height = 0;
    if(!m_displayedQuery.hasCompleted)
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
    if(m_isAnimatingOut)
    {
        return;
    }
    
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

-(CGFloat) getHeightForSet : (NSInteger) setIndex
{
    if(!m_displayedQuery.hasCompleted)
    {
        return m_searchInProgressCellHeight;
    }
    
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: setIndex];
    CGFloat visibleCellHeight = [setViewModel getVisibleResultCount] * setViewModel.expectedCellHeight;
    CGFloat moreToShowCellHeight = setViewModel.hasMoreToShow ? m_moreResultsCellHeight : 0;
    
    return visibleCellHeight + moreToShowCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!m_displayedQuery.hasCompleted)
    {
        return m_searchInProgressCellHeight;
    }
    
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: [indexPath section]];
    if([setViewModel isMoreResultsCell: [indexPath row]])
    {
        return m_moreResultsCellHeight;
    }
    return setViewModel.expectedCellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection: (NSInteger)section
{
    // returning 0 causes the table to use the default value (32)
    return CGFLOAT_MIN;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection: (NSInteger)section
{
    // returning 0 causes the table to use the default value (8)
    return CGFLOAT_MIN;
}

@end
