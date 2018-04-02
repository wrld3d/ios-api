#import "WRLDSearchWidgetResultsTableDataSource.h"
#import "WRLDSearchRequestFulfillerHandle.h"
#import "WRLDSearchResultSelectedObserver+Private.h"
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchTypes.h"
#import "WRLDSearchWidgetResultSetViewModel.h"

typedef NSMutableArray<WRLDSearchWidgetResultSetViewModel *> ResultSetViewModelCollection;


@implementation WRLDSearchWidgetResultsTableDataSource
{
    ResultSetViewModelCollection * m_providerViewModels;
    WRLDSearchQuery *m_displayedQuery;
    
    NSMutableArray<SearchResultsSourceEvent>* m_resultsSectionExpandedEvents;
    NSMutableArray<SearchResultsSourceEvent>* m_resultsSectionsCollapsedEvents;
}

- (instancetype) initWithDefaultCellIdentifier: (NSString *) defaultCellIdentifier
{
    self = [super init];
    if(self)
    {
        _selectionObserver = [[WRLDSearchResultSelectedObserver alloc] init];
        m_providerViewModels = [[ResultSetViewModelCollection alloc] init];
        
        _defaultCellIdentifier = defaultCellIdentifier;
        _moreResultsCellIdentifier = @"WRLDMoreResultsTableViewCell";
        
        m_resultsSectionExpandedEvents = [[NSMutableArray<SearchResultsSourceEvent> alloc] init];
        m_resultsSectionsCollapsedEvents = [[NSMutableArray<SearchResultsSourceEvent> alloc] init];
        
    }
    
    return self;
}

#pragma mark - WRLDSearchWidgetResultsTableDataSource

- (BOOL) isAwaitingData
{
    return m_displayedQuery != nil && ![m_displayedQuery hasCompleted];
}

- (NSInteger) providerCount
{
    return [m_providerViewModels count];
}

- (void) updateResultsFrom: (WRLDSearchQuery *) query
{
    m_displayedQuery = query;
    for(WRLDSearchWidgetResultSetViewModel *set in m_providerViewModels)
    {
        [set updateResultData: [query getResultsForFulfiller: set.fulfiller.identifier]];
    }
    [self collapseAllSections];
}

- (void) clearResults
{
    m_displayedQuery = nil;
    WRLDSearchResultsCollection* emptyResults = [[WRLDSearchResultsCollection alloc] init];
    for (WRLDSearchWidgetResultSetViewModel *set in m_providerViewModels)
    {
        [set updateResultData:emptyResults];
    }
    [self collapseAllSections];
}

- (NSString*) getDisplayedQueryText
{
    if(m_displayedQuery != nil)
    {
        return m_displayedQuery.queryString;
    }
    return nil;
}

-(NSString *) getIdentifierForCellAtPosition:(NSIndexPath *) index
{
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: [index section]];
    
    if([setViewModel isMoreResultsCell: [index row]])
    {
        return self.moreResultsCellIdentifier;
    }
    
    return setViewModel.fulfiller.cellIdentifier == nil ? self.defaultCellIdentifier : setViewModel.fulfiller.cellIdentifier;
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
}

- (void) stopDisplayingResultsFrom:(id<WRLDSearchRequestFulfillerHandle>)fulfiller
{
    WRLDSearchWidgetResultSetViewModel* modelToRemove = nil;
    for(WRLDSearchWidgetResultSetViewModel* viewModel in m_providerViewModels)
    {
        if(viewModel.fulfiller.identifier == fulfiller.identifier)
        {
            modelToRemove = viewModel;
            break;
        }
    }
    if(modelToRemove != nil)
    {
        [m_providerViewModels removeObject: modelToRemove];
    }
}

- (void) expandSection: (NSInteger) expandedSectionPosition
{
    _visibleResults = 0;
    for(NSInteger i = 0; i < [m_providerViewModels count]; ++i)
    {
        ExpandedStateType stateForProvider = (i == expandedSectionPosition) ? Expanded : Hidden;
        WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: i];
        [setViewModel setExpandedState: stateForProvider];
        _visibleResults += [setViewModel getVisibleResultCountWhen: stateForProvider];
    }
    [self searchResultSectionExpanded];
}

- (void) collapseAllSections
{
    _visibleResults = 0;
    for(WRLDSearchWidgetResultSetViewModel * setViewModel in m_providerViewModels)
    {
        [setViewModel setExpandedState: Collapsed];
        _visibleResults += [setViewModel getVisibleResultCountWhen: Collapsed];
    }
    
    [self searchResultSectionsCollapsed];
}

- (void) selected: (NSIndexPath *) indexPath
{
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: [indexPath section]];
    id<WRLDSearchResultModel> selectedResultModel = [setViewModel getResult:[indexPath row]];
    [setViewModel.fulfiller.selectionObserver selected: selectedResultModel];
    [self.selectionObserver selected:selectedResultModel];
}

- (void) populateCell: (WRLDSearchResultTableViewCell *)cell withDataFor:(NSIndexPath *)indexPath
{
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: [indexPath section]];
    id<WRLDSearchResultModel> resultModel = [setViewModel getResult : [indexPath row]];
    [cell populateWith: resultModel fromQuery: m_displayedQuery];
}

-(WRLDSearchWidgetResultSetViewModel *) getViewModelForProviderAt: (NSInteger) section
{
    return [m_providerViewModels objectAtIndex:section];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_displayedQuery != nil && !m_displayedQuery.hasCompleted)
    {
        return 0;
    }
    
    return [m_providerViewModels count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(m_displayedQuery != nil && !m_displayedQuery.hasCompleted)
    {
        return 0;
    }
    
    WRLDSearchWidgetResultSetViewModel * providerViewModel = [m_providerViewModels objectAtIndex:section];
    NSInteger cellsToDisplay = [providerViewModel getVisibleResultCountWhen: providerViewModel.expandedState];
    if([providerViewModel hasMoreResultsCellWhen: providerViewModel.expandedState])
    {
        ++cellsToDisplay;
    }
    return cellsToDisplay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *expectedCellIdentifier =[self getIdentifierForCellAtPosition: indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: expectedCellIdentifier];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: self.defaultCellIdentifier];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (NSInteger)getTotalResultCount
{
    NSInteger count = 0;
    
    for(NSInteger i = 0; i < [m_providerViewModels count]; ++i)
    {
        WRLDSearchWidgetResultSetViewModel * setViewModel = [m_providerViewModels objectAtIndex: i];
        count += [setViewModel getResultCount];
    }
    
    return count;
}

- (void) addResultsSectionExpandedEvent: (SearchResultsSourceEvent)event
{
    if(event)
    {
        [m_resultsSectionExpandedEvents addObject:event];
    }
}

- (void) removeResultsSectionExpandedEvent: (SearchResultsSourceEvent)event
{
    if(event)
    {
        [m_resultsSectionExpandedEvents removeObject:event];
    }
}

- (void) addResultsSectionsCollapsedEvent: (SearchResultsSourceEvent)event
{
    if(event)
    {
        [m_resultsSectionsCollapsedEvents addObject:event];
    }
}

- (void) removeResultsSectionsCollapsedEvent: (SearchResultsSourceEvent)event
{
    if(event)
    {
        [m_resultsSectionsCollapsedEvents removeObject:event];
    }
}

- (void) searchResultSectionExpanded
{
    for( SearchResultsSourceEvent event in m_resultsSectionExpandedEvents)
    {
        event();
    }
}

- (void) searchResultSectionsCollapsed
{
    for( SearchResultsSourceEvent event in m_resultsSectionsCollapsedEvents)
    {
        event();
    }
}

@end

