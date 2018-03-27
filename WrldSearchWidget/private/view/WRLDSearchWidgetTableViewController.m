#import "WRLDSearchWidgetTableViewController.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchTypes.h"
#import "WRLDSearchWidgetResultSetViewModel.h"
#import "WRLDSearchRequestFulfillerHandle.h"
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDMoreResultsTableViewCell.h"
#import "WRLDSearchInProgressTableViewCell.h"
#import "WRLDSearchResultModel.h"
#import "WRLDSearchResultSelectedObserver.h"
#import "WRLDSearchResultSelectedObserver+Private.h"
#import "WRLDSearchWidgetStyle.h"
#import "WRLDSearchWidgetResultsTableDataSource.h"

typedef NS_ENUM(NSInteger, GradientState) {
    None,
    Top,
    Bottom,
    TopAndBottom
};

@implementation WRLDSearchWidgetTableViewController
{
    UITableView * m_tableView;
    UIView * m_visibilityView;
    NSLayoutConstraint * m_heightConstraint;
    
    WRLDSearchWidgetResultsTableDataSource * m_dataSource;
    
    WRLDSearchWidgetStyle * m_style;
    
    CGFloat m_fadeDuration;
    
    CGFloat m_searchInProgressCellHeight;
    CGFloat m_moreResultsCellHeight;
    
    NSString * m_showMoreResultsText;
    NSString * m_backToResultsText;
    
    UIImage *m_imgMoreResultsIcon;
    UIImage *m_imgBackIcon;
    
    bool m_isAnimatingOut;
}

- (instancetype) initWithTableView: (UITableView *) tableView
                        dataSource: (WRLDSearchWidgetResultsTableDataSource *) dataSource
                    visibilityView: (UIView*) visibilityView
                  heightConstraint: (NSLayoutConstraint *) heightConstraint
                             style: (WRLDSearchWidgetStyle *) style
{
    self = [super init];
    if(self)
    {
        m_tableView = tableView;
        m_dataSource = dataSource;
        m_visibilityView = visibilityView;
        m_heightConstraint = heightConstraint;
        
        m_tableView.delegate = self;
        m_tableView.dataSource = m_dataSource;
        
        m_showMoreResultsText = @"Show More (%d) %@ results";
        m_backToResultsText = @"Back";
        m_isAnimatingOut = false;
        m_fadeDuration = 0.2f;
        
        m_searchInProgressCellHeight = 32;
        m_moreResultsCellHeight = 32;
        
        m_style = style;
        
        [self assignCellResourcesTo: m_tableView];
        
        [m_style call:^(UIColor *color) {
            [m_tableView setSeparatorColor: color];
        } toApply:WRLDSearchWidgetStyleMinorDividerColor];
    }
    
    return self;
}

- (void) assignCellResourcesTo: (UITableView *) tableView
{
    NSBundle* resourceBundle = [NSBundle bundleForClass:[WRLDSearchResultTableViewCell class]];
    
    [tableView registerNib:[UINib nibWithNibName: m_dataSource.defaultCellIdentifier bundle:resourceBundle]
    forCellReuseIdentifier: m_dataSource.defaultCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:m_dataSource.moreResultsCellIdentifier bundle: resourceBundle]
    forCellReuseIdentifier: m_dataSource.moreResultsCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:m_dataSource.searchInProgressCellIdentifier bundle: resourceBundle]
    forCellReuseIdentifier: m_dataSource.searchInProgressCellIdentifier];
    
    m_imgMoreResultsIcon = [UIImage imageNamed:@"MoreResults_Icon.png" inBundle: resourceBundle compatibleWithTraitCollection:nil];
    m_imgBackIcon = [UIImage imageNamed:@"SmallBackArrow_Icon.png" inBundle: resourceBundle compatibleWithTraitCollection:nil];
}

- (void) refreshTable
{
    [self safelyReloadData];
    [self resizeTable];
}

-(void) safelyReloadData
{
    if([m_dataSource providerCount] > 0)
    {
        [m_tableView reloadData];
    }
}

- (void) resizeTable
{
    CGFloat height = 0;
    if(m_dataSource.isAwaitingData)
    {
        height = m_searchInProgressCellHeight;
    }
    else
    {
        for(NSInteger dataSourceIndex = 0; dataSourceIndex < [m_dataSource providerCount]; ++ dataSourceIndex)
        {
            WRLDSearchWidgetResultSetViewModel * setViewModel = [m_dataSource getViewModelForProviderAt:dataSourceIndex];
            height += [setViewModel getResultsCellHeightWhen: setViewModel.expandedState];
            height += [setViewModel hasMoreResultsCellWhen: setViewModel.expandedState] ? m_moreResultsCellHeight : 0;
        }
    }
    
    [UIView animateWithDuration: m_fadeDuration animations:^{
        m_heightConstraint.constant = height;
        [m_visibilityView.superview layoutIfNeeded];
        [m_tableView setContentOffset:CGPointZero animated:YES];
    } completion:^(BOOL finished) {
        if(finished)
        {
            [m_tableView setContentOffset:CGPointZero animated:NO];
            [self applyGradient: [self getGradientState: m_tableView]];
        }
    }];
}

- (void) populateMoreResultsCell: (WRLDMoreResultsTableViewCell *) moreResultsCell fromViewModel: (WRLDSearchWidgetResultSetViewModel *) sectionViewModel
{
    [moreResultsCell applyStyle: m_style];
    if(sectionViewModel.expandedState == Collapsed)
    {
        NSString * textContent = [NSString stringWithFormat:m_showMoreResultsText, ([sectionViewModel getResultCount] - [sectionViewModel getVisibleResultCountWhen: Collapsed]), sectionViewModel.fulfiller.moreResultsName];
        [moreResultsCell populateWith: textContent icon: m_imgMoreResultsIcon];
    }
    else if(sectionViewModel.expandedState == Expanded)
    {
        [moreResultsCell populateWith: m_backToResultsText icon: m_imgBackIcon];
    }
}

-(GradientState) getGradientState : (UIScrollView*) scrollView
{
    bool contentExtendsAboveTopOfView = (scrollView.contentOffset.y + scrollView.contentInset.top > 0);
    bool contentExtendsBelowBottomOfView = (scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height);
    
    GradientState applyGradientTo = None;
    
    if(contentExtendsAboveTopOfView && contentExtendsBelowBottomOfView){
        applyGradientTo = TopAndBottom;
    }
    else if(contentExtendsAboveTopOfView){
        applyGradientTo = Top;
    }
    else if(contentExtendsBelowBottomOfView){
        applyGradientTo = Bottom;
    }
    return applyGradientTo;
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

#pragma mark - WRLDViewVisibilityController

- (void) show
{
    if(!m_visibilityView.hidden)
    {
        return;
    }
    
    [UIView animateWithDuration: m_fadeDuration animations:^{
        m_visibilityView.alpha = 1.0;
    }];
    m_visibilityView.hidden = NO;
}

- (void) hide
{
    if(m_isAnimatingOut || m_visibilityView.hidden)
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

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_dataSource.isAwaitingData)
    {
        WRLDSearchInProgressTableViewCell* inProgressCell = (WRLDSearchInProgressTableViewCell *) cell;
        [inProgressCell applyStyle: m_style];
        return;
    }
    
    WRLDSearchWidgetResultSetViewModel *sectionViewModel = [m_dataSource getViewModelForProviderAt: [indexPath section]];
    if([sectionViewModel isMoreResultsCell: [indexPath row]])
    {
        WRLDMoreResultsTableViewCell* moreResultsCell = (WRLDMoreResultsTableViewCell *) cell;
        [self populateMoreResultsCell: moreResultsCell fromViewModel: sectionViewModel];
        return;
    }
    
    WRLDSearchResultTableViewCell * resultCell = (WRLDSearchResultTableViewCell *) cell;
    [resultCell applyStyle: m_style];
    [m_dataSource populateCell:resultCell withDataFor: indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_dataSource.isAwaitingData)
    {
        return m_searchInProgressCellHeight;
    }
    
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_dataSource getViewModelForProviderAt: [indexPath section]];
    if([setViewModel isMoreResultsCell: [indexPath row]])
    {
        return m_moreResultsCellHeight;
    }
    return setViewModel.fulfiller.cellHeight;
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
    if(m_dataSource.isAwaitingData)
    {
        return;
    }
    
    WRLDSearchWidgetResultSetViewModel * setViewModel = [m_dataSource getViewModelForProviderAt: [indexPath section]];
    if([setViewModel isMoreResultsCell: [indexPath row]])
    {
        if(setViewModel.expandedState == Collapsed)
        {
            [m_dataSource expandSection: [indexPath section]];
            CGFloat onlySetHeight = [setViewModel getResultsCellHeightWhen: Collapsed] + m_moreResultsCellHeight;
            [UIView animateWithDuration: m_fadeDuration animations:^{
                m_heightConstraint.constant = onlySetHeight;
                [m_visibilityView.superview layoutIfNeeded];
                [m_tableView setContentOffset:CGPointZero animated:YES];
            } completion:^(BOOL finished) {
                if(finished)
                {
                    [self refreshTable];
                }
            }];
        }
        else
        {
            [m_dataSource collapseAllSections];
            [self refreshTable];
        }
    }
    else
    {
        [m_dataSource selected: indexPath];
    }
}

-(void) scrollViewDidScroll: (UIScrollView *)scrollView
{
    [self applyGradient: [self getGradientState:scrollView]];
}

@end
