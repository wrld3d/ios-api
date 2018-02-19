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
    
    NSString * m_moreResultsCellStyleIdentifier;
    NSString * m_searchInProgressCellStyleIdentifier;
    NSString * m_showMoreResultsText;
    NSString * m_backToResultsText;
    
    UIImage *m_imgMoreResultsIcon;
    UIImage *m_imgBackIcon;
    
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
        
        m_showMoreResultsText = @"Show More (%d) %@ results";
        m_backToResultsText = @"Back";
        
        m_searchInProgressCellHeight = 48;
        m_moreResultsCellHeight = 32;
        
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
    
    m_imgMoreResultsIcon = [UIImage imageNamed:@"MoreResults_butn.png" inBundle: resourceBundle compatibleWithTraitCollection:nil];
    m_imgBackIcon = [UIImage imageNamed:@"Back_btn.png" inBundle: resourceBundle compatibleWithTraitCollection:nil];
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

- (void) resizeTable
{
    CGFloat height = 0;
    if(!m_displayedQuery.hasCompleted)
    {
        height = m_searchInProgressCellHeight;
    }
    else
    {
        for(WRLDSearchWidgetResultSetViewModel * setViewModel in m_providerViewModels)
        {
            height += [setViewModel getResultsCellHeightWhen: setViewModel.expandedState];
            height += [setViewModel hasMoreResultsCellWhen: setViewModel.expandedState] ? m_moreResultsCellHeight : 0;
        }
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
        if(finished)
        {
            m_visibilityView.hidden =  YES;
            m_isAnimatingOut = false;
        }
    }];
}

- (void) expandSection: (NSInteger) expandedSectionPosition
{
    for(NSInteger i = 0; i < [m_providerViewModels count]; ++i)
    {
        ExpandedStateType stateForProvider = (i == expandedSectionPosition) ? Expanded : Hidden;
        [[m_providerViewModels objectAtIndex: i] setExpandedState: stateForProvider];
    }
}

- (void) collapseAllSections
{
    for(WRLDSearchWidgetResultSetViewModel * setViewModel in m_providerViewModels)
    {
        [setViewModel setExpandedState: Collapsed];
    }
}

- (void) populateMoreResultsCell: (WRLDMoreResultsTableViewCell *) moreResultsCell fromViewModel: (WRLDSearchWidgetResultSetViewModel *) sectionViewModel
{
    if(sectionViewModel.expandedState == Collapsed)
    {
        NSString * textContent = [NSString stringWithFormat:m_showMoreResultsText, ([sectionViewModel getResultCount] - [sectionViewModel getVisibleResultCountWhen: Collapsed]), sectionViewModel.moreResultsName];
        [moreResultsCell populateWith: textContent icon: m_imgMoreResultsIcon];
    }
    else if(sectionViewModel.expandedState == Expanded)
    {
        [moreResultsCell populateWith: m_backToResultsText icon: m_imgBackIcon];
    }
}

#pragma mark - UITableViewDataSource

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!m_displayedQuery.hasCompleted)
    {
        return 1;
    }
    
    return [m_providerViewModels count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(!m_displayedQuery.hasCompleted)
    {
        return 1;
    }
    
    WRLDSearchWidgetResultSetViewModel * providerViewModel = [m_providerViewModels objectAtIndex:section];
    NSInteger cellsToDisplay = [providerViewModel getVisibleResultCountWhen: providerViewModel.expandedState];
    if([providerViewModel hasMoreResultsCellWhen: providerViewModel.expandedState])
    {
        ++cellsToDisplay;
    }
    return cellsToDisplay;
}

#pragma mark - UITableViewDelegate

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
        [self populateMoreResultsCell: moreResultsCell fromViewModel: sectionViewModel];
        return;
    }
    
    id<WRLDSearchResultModel> resultModel = [sectionViewModel getResult : [indexPath row]];
    WRLDSearchResultTableViewCell * resultCell = (WRLDSearchResultTableViewCell *) cell;
    [resultCell populateWith: resultModel highlighting: m_displayedQuery.queryString];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!m_displayedQuery.hasCompleted)
    {
        return;
    }
    
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: [indexPath section]];
    if([setViewModel isMoreResultsCell: [indexPath row]])
    {
        if(setViewModel.expandedState == Collapsed)
        {
            [self expandSection: [indexPath section]];
            CGFloat onlySetHeight = [setViewModel getResultsCellHeightWhen: Collapsed] + m_moreResultsCellHeight;
            [UIView animateWithDuration: m_fadeDuration animations:^{
                m_heightConstraint.constant = onlySetHeight;
                [m_visibilityView layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                if(finished)
                {
                    [m_tableView reloadData];
                    [self resizeTable];
                }
            }];
        }
        else
        {
            [self collapseAllSections];
            [m_tableView reloadData];
            [self resizeTable];
        }
    }
    else
    {
        // TODO clicked a result
    }
}

@end
