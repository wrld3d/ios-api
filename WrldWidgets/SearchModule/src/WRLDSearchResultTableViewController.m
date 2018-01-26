#import <Foundation/Foundation.h>
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchResult.h"
#import "WRLDSearchResultTableViewController.h"
#import "WRLDSearchResultSet.h"
#import "SearchProviders.h"

@implementation WRLDSearchResultTableViewController
{
    WRLDSearchQuery *m_currentQuery;
    UIView * m_tableViewContainer;
    UITableView * m_tableView;
    NSLayoutConstraint * m_heightConstraint;
    NSString* m_defaultCellStyleIdentifier;
    NSString* m_footerCellStyleIentifier;
    NSString* m_searchingCellStyleIentifier;
    SearchProviders * m_searchProviders;
    bool m_isAnimatingOut;
}

-(instancetype) init : (UIView *) tableViewContainer :(UITableView *) tableView : (SearchProviders *) searchProviders
{
    self = [super init];
    if(self)
    {
        m_tableViewContainer = tableViewContainer;
        m_tableView = tableView;
        m_defaultCellStyleIdentifier = @"WRLDGenericSearchResult";
        m_footerCellStyleIentifier = @"WRLDDisplayMoreResultsCell";
        m_searchingCellStyleIentifier = @"WRLDSearchInProgressCell";
        m_searchProviders = searchProviders;
        m_isAnimatingOut = false;
        
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_tableView.sectionFooterHeight = 0;
        
        NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchResultTableViewCell class]];
        [tableView registerNib:[UINib nibWithNibName:m_defaultCellStyleIdentifier bundle:widgetsBundle] forCellReuseIdentifier: m_defaultCellStyleIdentifier];
        [tableView registerNib:[UINib nibWithNibName:m_footerCellStyleIentifier bundle:widgetsBundle] forCellReuseIdentifier: m_footerCellStyleIentifier];
        [tableView registerNib:[UINib nibWithNibName:m_searchingCellStyleIentifier bundle:widgetsBundle] forCellReuseIdentifier: m_searchingCellStyleIentifier];
    }
    
    return self;
}

-(void) setCurrentQuery:(WRLDSearchQuery *)newQuery
{
    m_currentQuery = newQuery;
    [newQuery setCompletionDelegate: self];
    [self updateResults];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getIdentifierForCellAtPosition: indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

-(NSString *) getIdentifierForCellAtPosition:(NSIndexPath *) index
{
    if([m_currentQuery progress] == InFlight){
        return m_searchingCellStyleIentifier;
    }
    
    if([self isFooter:index])
    {
        return m_footerCellStyleIentifier;
    }
    
    return [m_searchProviders getCellIdentifierForSetAtIndex: [index section]];
}

-(bool) isFooter: (NSIndexPath * ) index
{
    WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: [index section]];
    if([self hasFooter : set])
    {
        return [index row] == [set getVisibleResultCount];
    }
    return false;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO Handle casting propertly
    if(![self isFooter:indexPath] && !([m_currentQuery progress] == InFlight))
    {
        WRLDSearchResultTableViewCell* castCell = (WRLDSearchResultTableViewCell*)cell;
    
        WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: [indexPath section]];
        WRLDSearchResult *result = [set getResult: [indexPath row]];
        [castCell.titleLabel setText:[result title]];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"numberOfSectionsInTableView %d", [m_resultSets count]);
    
    if([m_currentQuery progress] == InFlight){
        return 1;
    }
    
    return [m_searchProviders count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    
    if([m_currentQuery progress] == InFlight){
        return 1;
    }
    
    WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: section];
    NSInteger visibleCells = [set getVisibleResultCount];
    if([self hasFooter : set])
    {
        visibleCells++;
    }
        
    return visibleCells;
}

- (bool) hasFooter : (WRLDSearchResultSet *) set
{
    return [set hasMoreToShow] || [set getExpandedState] == Expanded;
}

-(void) updateResults
{
    //NSLog(@"updateResults");
    [m_tableView reloadData];
    //CGRect bounds = m_tableView.bounds;
    
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
        m_tableViewContainer.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(finished){
            [self applyGradient: [self getGradientState:m_tableView]];
        }
    }];
    m_tableViewContainer.hidden = NO;
}

-(CGFloat) getHeightForSet : (NSInteger) setIndex
{
    CGFloat height = 0;
    WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: setIndex];
    int cellsInSection = [set getVisibleResultCount];
    
    if([self hasFooter : set]){
        ++cellsInSection;
    }
    
    for(int i = 0; i < cellsInSection; ++i)
    {
        height += [self tableView:m_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:setIndex]];
    }
    
    height += 8;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isFooter:indexPath])
    {
        return 32;
    }
    return [m_searchProviders getCellExpectedHeightForSetAtIndex: [indexPath section]];
}

-(void) setHeightConstraint:(NSLayoutConstraint *)heightConstraint
{
    m_heightConstraint = heightConstraint;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isFooter: indexPath])
    {
        NSInteger section = [indexPath section];
        WRLDSearchResultSet * selectedSet = [m_currentQuery getResultSetForProviderAtIndex: section];
        if([selectedSet getExpandedState] == Expanded)
        {
            for(int i = 0; i < [m_searchProviders count]; ++i)
            {
                WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: i];
                [set setExpandedState:Collapsed];
            }
        }
        else{
            for(int i = 0; i < [m_searchProviders count]; ++i)
            {
                WRLDSearchResultSet * set = [m_currentQuery getResultSetForProviderAtIndex: i];
                [set setExpandedState:(section == i) ? Expanded : Hidden];
            }
        }
        [self updateResults];
    }
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [tableView headerViewForSection:section];
    if(view)
    {
        return view;
    } else
    {
        return [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 8)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void) fadeOut
{
    if(!m_isAnimatingOut)
    {
        m_isAnimatingOut = true;
        [UIView animateWithDuration: 0.25 animations:^{
            m_tableViewContainer.alpha = 0.0;
        } completion:^(BOOL finished) {
            if(finished){
                m_tableViewContainer.hidden =  YES;
                m_isAnimatingOut = false;
            }
        }];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self applyGradient: [self getGradientState:scrollView]];
}

-(GradientState) getGradientState : (UIScrollView*) scrollView
{
    bool belowTop = false;
    bool aboveBottom = false;
    if (scrollView.contentOffset.y + scrollView.contentInset.top > 0) {
        belowTop = true;
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height) {
        aboveBottom = true;
    }
    
    if(belowTop && aboveBottom){
        return TopAndBottom;
    }
    if(belowTop){
        return Top;
    }
    if(aboveBottom){
        return Bottom;
    }
    return None;
}

-(void) applyGradient: (GradientState) state
{
    CAGradientLayer* gradient = [[CAGradientLayer alloc] init];
    gradient.frame = [m_tableView bounds];
    
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    switch (state) {
        case None:
            m_tableView.layer.mask = nil;
            break;
        case Top:
            gradient.colors = @[(__bridge id)innerColor, (__bridge id)outerColor];
            gradient.locations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.2]];
            m_tableView.layer.mask = gradient;
            break;
        case Bottom:
            gradient.colors = @[(__bridge id)outerColor, (__bridge id)innerColor];
            gradient.locations = @[[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:1.0]];
            m_tableView.layer.mask = gradient;
            break;
        case TopAndBottom:
            gradient.colors = @[(__bridge id)innerColor, (__bridge id)outerColor, (__bridge id)outerColor, (__bridge id)innerColor];
            gradient.locations = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:1.0]];
            m_tableView.layer.mask = gradient;
            break;
    }
}

@end
