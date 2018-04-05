#import "WRLDSearchMenuViewController.h"
#import "WRLDSearchMenuModel.h"
#import "WRLDSearchMenuModel+Private.h"
#import "WRLDMenuGroupTitleTableViewCell.h"
#import "WRLDMenuOptionTableViewCell.h"
#import "WRLDMenuChildTableViewCell.h"
#import "WRLDMenuGroup.h"
#import "WRLDMenuGroup+Private.h"
#import "WRLDMenuOption.h"
#import "WRLDMenuChild.h"
#import "WRLDSearchWidgetStyle.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDMenuObserver+Private.h"

typedef NSMutableArray<WRLDMenuTableSectionViewModel *> TableSectionViewModelCollection;

typedef NS_ENUM(NSInteger, GradientState) {
    None,
    Top,
    Bottom,
    TopAndBottom
};

@implementation WRLDSearchMenuViewController
{
    WRLDSearchMenuModel* m_menuModel;
    UIView* m_visibilityView;
    UILabel* m_titleLabel;
    UITableView* m_tableView;
    UIView* m_tableFadeTopView;
    UIView* m_tableFadeBottomView;
    NSLayoutConstraint* m_heightConstraint;
    WRLDSearchWidgetStyle* m_style;
    TableSectionViewModelCollection* m_sectionViewModels;
    
    NSString* m_menuGroupTitleTableViewCellStyleIdentifier;
    NSString* m_menuOptionTableViewCellStyleIdentifier;
    NSString* m_menuChildTableViewCellStyleIdentifier;
    
    UIImage* m_imgExpanderBlueIcon;
    UIImage* m_imgExpanderWhiteIcon;
    
    CGFloat m_menuHeaderHeightIncludingSeparator;
    CGFloat m_groupSeparatorHeight;
}

- (instancetype) initWithVisibilityView:(UIView *)visibilityView
                     titleLabel:(UILabel *)titleLabel
                  separatorView:(UIView *)separatorView
                      tableView:(UITableView *)tableView
               tableFadeTopView:(UIView *)tableFadeTopView
            tableFadeBottomView:(UIView *)tableFadeBottomView
               heightConstraint:(NSLayoutConstraint *)heightConstraint
                          style:(WRLDSearchWidgetStyle *)style
{
    self = [super init];
    if (self)
    {
        m_menuModel = nil;
        m_visibilityView = visibilityView;
        m_titleLabel = titleLabel;
        m_tableView = tableView;
        m_tableFadeTopView = tableFadeTopView;
        m_tableFadeBottomView = tableFadeBottomView;
        m_heightConstraint = heightConstraint;
        m_style = style;
        
        m_menuGroupTitleTableViewCellStyleIdentifier = @"WRLDMenuGroupTitleTableViewCell";
        m_menuOptionTableViewCellStyleIdentifier = @"WRLDMenuOptionTableViewCell";
        m_menuChildTableViewCellStyleIdentifier = @"WRLDMenuChildTableViewCell";
        
        m_menuHeaderHeightIncludingSeparator = 48.0f;
        m_groupSeparatorHeight = 4.0f;
        
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        
        _observer = [[WRLDMenuObserver alloc] init];
        
        m_sectionViewModels = [[TableSectionViewModelCollection alloc] init];
        
        separatorView.backgroundColor = [style colorForStyle: WRLDSearchWidgetStyleMajorDividerColor];
        
        [self assignCellResourcesTo:m_tableView];
        [self initTableFadeViews];        
    }
    
    return self;
}

- (void) setModel: (WRLDSearchMenuModel *) menuModel
{
    m_menuModel = menuModel;
    [m_menuModel setListener:self];
    [self updateSectionViewModels];
    [self updateTitleLabelText];
    [self refreshMenuTable];
}

- (void) removeModel
{
    m_menuModel = nil;
    [m_menuModel setListener: nil];
    [self updateSectionViewModels];
    [self updateTitleLabelText];
    [self refreshMenuTable];
}

- (void)assignCellResourcesTo:(UITableView *)tableView
{
    NSBundle* resourceBundle = [NSBundle bundleForClass:[WRLDMenuGroupTitleTableViewCell class]];
    
    [tableView registerNib:[UINib nibWithNibName:m_menuGroupTitleTableViewCellStyleIdentifier bundle:resourceBundle]
    forCellReuseIdentifier:m_menuGroupTitleTableViewCellStyleIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:m_menuOptionTableViewCellStyleIdentifier bundle:resourceBundle]
    forCellReuseIdentifier:m_menuOptionTableViewCellStyleIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:m_menuChildTableViewCellStyleIdentifier bundle:resourceBundle]
    forCellReuseIdentifier:m_menuChildTableViewCellStyleIdentifier];
    
    m_imgExpanderBlueIcon = [UIImage imageNamed:@"Expander_Icon.png" inBundle:resourceBundle compatibleWithTraitCollection:nil];
    m_imgExpanderWhiteIcon = [UIImage imageNamed:@"ExpanderWhite_Icon.png" inBundle:resourceBundle compatibleWithTraitCollection:nil];
}

- (void)initTableFadeViews
{
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    CAGradientLayer* topGradient = [[CAGradientLayer alloc] init];
    topGradient.frame = [m_tableFadeTopView bounds];
    topGradient.colors = @[(__bridge id)outerColor, (__bridge id)innerColor];
    topGradient.locations = @[@0.0,@1.0];
    m_tableFadeTopView.layer.mask = topGradient;

    CAGradientLayer* bottomGradient = [[CAGradientLayer alloc] init];
    bottomGradient.frame = [m_tableFadeBottomView bounds];
    bottomGradient.colors = @[(__bridge id)innerColor, (__bridge id)outerColor];
    bottomGradient.locations = @[@0.0,@1.0];
    m_tableFadeBottomView.layer.mask = bottomGradient;
}

- (void)updateTitleLabelText
{
    if(m_menuModel == nil)
    {
        return;
    }
    
    m_titleLabel.text = m_menuModel.title;
}

- (void)updateSectionViewModels
{
    [m_sectionViewModels removeAllObjects];
    
    if(m_menuModel == nil)
    {
        return;
    }
    
    for (WRLDMenuGroup* menuGroup in [m_menuModel getGroups])
    {
        if ([menuGroup hasTitle])
        {
            [m_sectionViewModels addObject:[[WRLDMenuTableSectionViewModel alloc] initWithMenuGroup:menuGroup]];
        }
        
        NSUInteger optionCount = [[menuGroup getOptions] count];
        for (NSUInteger optionIndex = 0; optionIndex < optionCount; ++optionIndex)
        {
            [m_sectionViewModels addObject:[[WRLDMenuTableSectionViewModel alloc] initWithMenuGroup:menuGroup
                                                                                        optionIndex:optionIndex]];
        }
    }
}

- (void)refreshMenuTable
{
    [m_tableView reloadData];
    [self resizeMenuTable];
}

- (void)resizeMenuTable
{
    CGFloat height = m_menuHeaderHeightIncludingSeparator;
    
    for (WRLDMenuTableSectionViewModel* sectionViewModel in m_sectionViewModels)
    {
        height += [sectionViewModel getViewHeight];
        if (sectionViewModel.expandedState == Expanded)
        {
            height += ([sectionViewModel getChildCount]) * [sectionViewModel getChildViewHeight];
        }
    }
    
    // Account for group separator height
    NSUInteger menuGroupCount = (m_menuModel == nil) ? 0 : [[m_menuModel getGroups] count];
    if (menuGroupCount > 0)
    {
        height += (menuGroupCount - 1) * m_groupSeparatorHeight;
    }
    
    m_heightConstraint.constant = height;
    [m_visibilityView layoutIfNeeded];
    
    [self resetScrollPositionIfMenuFitsOnScreen];
    [self updateTableFadeViews:NO];
}

- (void)resetScrollPositionIfMenuFitsOnScreen
{
    if (m_tableView.frame.size.height == m_tableView.contentSize.height)
    {
        [m_tableView setContentOffset:CGPointZero];
    }
}

- (NSString *)getIdentifierForCellAtPosition:(NSIndexPath *)indexPath
{
    WRLDMenuTableSectionViewModel* sectionViewModel = [m_sectionViewModels objectAtIndex:[indexPath section]];
    
    if ([sectionViewModel isTitleSection])
    {
        return m_menuGroupTitleTableViewCellStyleIdentifier;
    }
    
    if ([indexPath row] == 0)
    {
        return m_menuOptionTableViewCellStyleIdentifier;
    }
    
    return m_menuChildTableViewCellStyleIdentifier;
}

- (void)updateTableFadeViews:(BOOL)animate
{
    bool contentExtendsAboveTopOfView = (m_tableView.contentOffset.y + m_tableView.contentInset.top > 0);
    bool contentExtendsBelowBottomOfView = (m_tableView.contentOffset.y + m_tableView.frame.size.height < m_tableView.contentSize.height);
    
    bool shouldApplyTopGradient = false;
    bool shouldApplyBottomGradient = false;
    
    if (contentExtendsAboveTopOfView && contentExtendsBelowBottomOfView)
    {
        shouldApplyTopGradient = true;
        shouldApplyBottomGradient = true;
    }
    else if (contentExtendsAboveTopOfView)
    {
        shouldApplyTopGradient = true;
    }
    else if (contentExtendsBelowBottomOfView)
    {
        shouldApplyBottomGradient = true;
    }
    
    CGFloat fadeDuration = animate ? 0.2f : 0.0f;
    
    [UIView animateWithDuration: fadeDuration animations:^{
        CGFloat alpha = shouldApplyTopGradient ? 1.0 : 0.0;
        [m_tableFadeTopView setAlpha:alpha];
        alpha = shouldApplyBottomGradient ? 1.0 : 0.0;
        [m_tableFadeBottomView setAlpha:alpha];
    }];
}

- (void)collapseAllSectionsAndNotifyExpandedStateChangeFromInteraction:(BOOL)fromInteraction
{
    for (WRLDMenuTableSectionViewModel* sectionViewModel in m_sectionViewModels)
    {
        [self setExpandedState:Collapsed
           forSectionViewModel:sectionViewModel
      andNotifyFromInteraction:fromInteraction];
    }
}

- (void)setExpandedState:(ExpandedStateType)ExpandedState
     forSectionViewModel:(WRLDMenuTableSectionViewModel *)sectionViewModel
andNotifyFromInteraction:(BOOL)fromInteraction
{
    if (sectionViewModel.expandedState != ExpandedState)
    {
        [sectionViewModel setExpandedState:ExpandedState];
        if (ExpandedState == Expanded)
        {
            [self.observer expanded:[sectionViewModel getContext]
                    fromInteraction:fromInteraction];
        }
        else if (ExpandedState == Collapsed)
        {
            [self.observer collapsed:[sectionViewModel getContext]
                     fromInteraction:fromInteraction];
        }
    }
}

- (WRLDMenuTableSectionViewModel *)getSectionViewModelForOptionIndex:(NSUInteger)optionIndex
{
    // Ignoring group titles as they are not options.
    NSUInteger i = 0;
    for (WRLDMenuTableSectionViewModel* sectionViewModel in m_sectionViewModels)
    {
        if ([sectionViewModel isTitleSection])
        {
            continue;
        }
        
        if (optionIndex == i)
        {
            return sectionViewModel;
        }
        ++i;
    }
    return nil;
}

- (void)showAndNotifyOpenedFromInteraction:(BOOL)fromInteraction
{
    if (m_visibilityView.hidden)
    {
        m_visibilityView.hidden = NO;
        [self.observer opened:fromInteraction];
    }
    [self updateTableFadeViews:NO];
}

- (void)hideAndNotifyClosedFromInteraction:(BOOL)fromInteraction
{
    if (!m_visibilityView.hidden)
    {
        m_visibilityView.hidden = YES;
        [self.observer closed:fromInteraction];
    }
}


#pragma mark - Public Methods

- (void)open
{
    [self showAndNotifyOpenedFromInteraction:NO];
}

- (void)close
{
    [self hideAndNotifyClosedFromInteraction:NO];
}

- (void)collapse
{
    [self collapseAllSectionsAndNotifyExpandedStateChangeFromInteraction:NO];
    [self refreshMenuTable];
}

- (void)expandAt:(NSUInteger)index
{
    WRLDMenuTableSectionViewModel* sectionToExpand = [self getSectionViewModelForOptionIndex:index];
    
    if (sectionToExpand != nil && [sectionToExpand isExpandable])
    {
        if (sectionToExpand.expandedState == Collapsed)
        {
            [self collapseAllSectionsAndNotifyExpandedStateChangeFromInteraction:NO];
            [self setExpandedState:Expanded
               forSectionViewModel:sectionToExpand
          andNotifyFromInteraction:NO];
        }
        [self refreshMenuTable];
    }
}

- (void)onMenuButtonClicked
{
    [self showAndNotifyOpenedFromInteraction:YES];
}

- (void)onMenuBackButtonClicked
{
    [self collapseAllSectionsAndNotifyExpandedStateChangeFromInteraction:YES];
    [self refreshMenuTable];
    [self hideAndNotifyClosedFromInteraction:YES];
}

- (BOOL)isMenuOpen
{
    return !m_visibilityView.hidden;
}

#pragma mark - WRLDMenuChangedListener

- (void)onMenuTitleChanged
{
    [self updateTitleLabelText];
}

- (void)onMenuChanged
{
    [self updateSectionViewModels];
    [self refreshMenuTable];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getIdentifierForCellAtPosition:indexPath];
    return [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_sectionViewModels count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    WRLDMenuTableSectionViewModel* sectionViewModel = [m_sectionViewModels objectAtIndex:section];
    NSInteger count = 1;
    if (sectionViewModel.expandedState == Expanded)
    {
        count += [sectionViewModel getChildCount];
    }
    return count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDMenuTableSectionViewModel* sectionViewModel = [m_sectionViewModels objectAtIndex:[indexPath section]];
    
    NSInteger row = [indexPath row];
    if (row == 0)
    {
        bool isFirstTableSection = [indexPath section] == 0;
        if ([sectionViewModel isTitleSection])
        {
            WRLDMenuGroupTitleTableViewCell* groupTitleCell = (WRLDMenuGroupTitleTableViewCell *)cell;
            [groupTitleCell populateWith:sectionViewModel
                     isFirstTableSection:isFirstTableSection
                                   style:m_style];
        }
        else
        {
            WRLDMenuOptionTableViewCell* optionCell = (WRLDMenuOptionTableViewCell *)cell;
            [optionCell populateWith:sectionViewModel
                 isFirstTableSection:isFirstTableSection
                        expanderIcon:m_imgExpanderBlueIcon
                     highlightedIcon:m_imgExpanderWhiteIcon
                               style:m_style];
        }
        
        return;
    }
    
    WRLDMenuChildTableViewCell* childCell = (WRLDMenuChildTableViewCell *)cell;
    NSUInteger childIndex = row - 1;
    [childCell populateWith:sectionViewModel
                 childIndex:childIndex
                      style:m_style];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDMenuTableSectionViewModel* sectionViewModel = [m_sectionViewModels objectAtIndex:[indexPath section]];
    
    CGFloat height = 0.0f;
    
    if ([indexPath row] == 0)
    {
        height = [sectionViewModel getViewHeight];
        
        if ([sectionViewModel isFirstOptionInGroup])
        {
            bool isFirstTableSection = [indexPath section] == 0;
            height += isFirstTableSection ? 0: m_groupSeparatorHeight;
        }
    }
    else
    {
        height = [sectionViewModel getChildViewHeight];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // returning 0 causes the table to use the default value (32)
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // returning 0 causes the table to use the default value (8)
    return CGFLOAT_MIN;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDMenuTableSectionViewModel* sectionViewModel = [m_sectionViewModels objectAtIndex:[indexPath section]];
    
    if ([sectionViewModel isTitleSection])
    {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDMenuTableSectionViewModel* sectionViewModel = [m_sectionViewModels objectAtIndex:[indexPath section]];
    NSObject* selectedOptionContext = nil;
    
    NSUInteger row = [indexPath row];
    if (row == 0)
    {
        selectedOptionContext = [sectionViewModel getContext];
        
        if ([sectionViewModel isExpandable])
        {
            bool shouldExpand = sectionViewModel.expandedState == Collapsed;
            [self collapseAllSectionsAndNotifyExpandedStateChangeFromInteraction:YES];
            if (shouldExpand)
            {
                [self setExpandedState:Expanded
                   forSectionViewModel:sectionViewModel
              andNotifyFromInteraction:YES];
            }
            [self refreshMenuTable];
        }
        else
        {
            [self.observer selected:selectedOptionContext];
        }
    }
    else
    {
        NSUInteger childIndex = row - 1;
        selectedOptionContext = [sectionViewModel getChildContextAtIndex:childIndex];
        [self.observer selected:selectedOptionContext];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateTableFadeViews:YES];
}

@end
