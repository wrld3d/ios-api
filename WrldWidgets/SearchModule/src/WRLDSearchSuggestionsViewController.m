#include "WRLDSearchSuggestionsViewController.h"
#include "SearchProviders.h"
#include "WRLDSearchQuery.h"
#include "WRLDSearchResultSet.h"
#include "WRLDSearchResult.h"
#include "WRLDSearchSuggestionTableViewCell.h"

@implementation WRLDSearchSuggestionsViewController
{
    WRLDSearchQuery *m_currentQuery;
    UITableView * m_tableView;
    NSLayoutConstraint * m_heightConstraint;
    NSString* m_cellStyleIdentifier;
    SearchProviders * m_searchProviders;
    SuggestionSelectedCallback m_suggestionSelectedCallback;
    
    bool m_isAnimatingOut;
}

-(instancetype) init : (UITableView *) tableView : (SearchProviders *) searchProviders :(SuggestionSelectedCallback) callback
{
    self = [super init];
    if(self)
    {
        m_tableView = tableView;
        m_searchProviders = searchProviders;
        m_isAnimatingOut = false;
        m_suggestionSelectedCallback = callback;
        m_cellStyleIdentifier = @"WRLDSearchWidgetSuggestion";
        
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        m_tableView.sectionHeaderHeight = 0;
        m_tableView.sectionFooterHeight = 0;
        
        NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchSuggestionTableViewCell class]];
        UINib * nib = [UINib nibWithNibName:m_cellStyleIdentifier bundle:widgetsBundle];
        [tableView registerNib:nib forCellReuseIdentifier: m_cellStyleIdentifier];
    }
    
    return self;
}

-(void) setCurrentQuery:(WRLDSearchQuery *)newQuery
{
    [self cancelInFlightQuery];
    m_currentQuery = newQuery;
    [newQuery setCompletionDelegate: self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellStyleIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO Handle casting propertly
    WRLDSearchSuggestionTableViewCell* castCell = (WRLDSearchSuggestionTableViewCell*)cell;
    WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: [indexPath section]];
    WRLDSearchResult *result = [set getResult: [indexPath row]];
    [castCell setTitleLabelText: result.title : m_currentQuery.queryString];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([m_currentQuery progress] == InFlight){
        return 0;
    }
    
    return [m_searchProviders count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: section];
    return [set getVisibleResultCount];
}

-(void) updateResults
{
    [m_tableView reloadData];
    [self fadeIn];
}

-(void) fadeIn
{
    CGFloat height = 0;
    if([m_currentQuery progress] == InFlight)
    {
        height = 48;
    }
    else
    {
        for(int i = 0; i < [m_searchProviders count]; ++i)
        {
            height += [self getHeightForSet: i];
        }
        height = MIN(400, height);
    }
    
    [UIView animateWithDuration: 0.25 animations:^{
        m_heightConstraint.constant = height;
        [m_tableView layoutIfNeeded];
        m_tableView.alpha = 1.0;
    }];
    m_tableView.hidden = NO;
}

-(CGFloat) getHeightForSet : (NSInteger) setIndex
{
    WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: setIndex];
    int cellsInSection = [set getVisibleResultCount];
    return 32 * cellsInSection;
}

-(void) setHeightConstraint:(NSLayoutConstraint *)heightConstraint
{
    m_heightConstraint = heightConstraint;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: [indexPath section]];
    WRLDSearchResult *result = [set getResult: [indexPath row]];
    m_suggestionSelectedCallback(result.title);
}

-(void) fadeOut
{
    if(!m_isAnimatingOut)
    {
        m_isAnimatingOut = true;
        [self cancelInFlightQuery];
        [UIView animateWithDuration: 0.25 animations:^{
            m_tableView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if(finished){
                m_tableView.hidden =  YES;
                m_isAnimatingOut = false;
            }
        }];
    }
}

-(void) cancelInFlightQuery
{
    if(m_currentQuery && m_currentQuery.progress == InFlight)
    {
        [m_currentQuery cancel];
    }
}
@end
