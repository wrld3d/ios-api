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
    NSLayoutConstraint * m_heightConstraint;
    ResultSetViewModelCollection * m_providerViewModels;
    NSString * m_defaultCellIdentifier;
    WRLDSearchQuery *m_displayedQuery;
    CGFloat m_fadeInDuration;
    
    bool m_isAnimatingOut;
}

- (instancetype) initWithTableView: (UITableView *) tableView defaultCellIdentifier: (NSString *) defaultCellIdentifier heightConstraint: (NSLayoutConstraint *) heightConstraint
{
    self = [super init];
    if(self)
    {
        m_tableView = tableView;
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_heightConstraint = heightConstraint;
        m_providerViewModels = [[ResultSetViewModelCollection alloc] init];
        m_isAnimatingOut = false;
        m_defaultCellIdentifier = defaultCellIdentifier;
        m_fadeInDuration = 1.0f;
    }
    
    return self;
}

- (void) showQuery: (WRLDSearchQuery *) sourceQuery
{
    m_displayedQuery = sourceQuery;
    for(WRLDSearchWidgetResultSetViewModel *set in m_providerViewModels)
    {
        [set updateResultData:[sourceQuery getResultsForFulfiller: set.fulfillerId]];
    }
    [self fadeIn];
    [m_tableView reloadData];
}

- (void) displayResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider
{
    WRLDSearchWidgetResultSetViewModel * newProviderViewModel = [[WRLDSearchWidgetResultSetViewModel alloc] initForRequestFulfiller:provider.identifier];
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

-(void) fadeIn
{
    CGFloat height = 0;
    if([m_displayedQuery progress] == InFlight)
    {
        height = 48;
    }
    else
    {
        for(int i = 0; i < [m_providerViewModels count]; ++i)
        {
            height += [self getHeightForSet: i];
        }
        height = MIN(400, height);
    }
    
    [UIView animateWithDuration: m_fadeInDuration animations:^{
        m_heightConstraint.constant = height;
        [m_tableView layoutIfNeeded];
        m_tableView.alpha = 1.0;
    }];
    m_tableView.hidden = NO;
}

-(CGFloat) getHeightForSet : (NSInteger) setIndex
{
    WRLDSearchWidgetResultSetViewModel *set = [m_providerViewModels objectAtIndex: setIndex];
    return 32 * [set getVisibleResultCount];
}

@end


