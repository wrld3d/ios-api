#import "WRLDSearchMenuViewController.h"
#import "WRLDSearchMenuModel.h"
#import "WRLDMenuGroupTitleTableViewCell.h"
#import "WRLDMenuOptionTableViewCell.h"
#import "WRLDMenuChildTableViewCell.h"
#import "WRLDMenuGroup.h"
#import "WRLDMenuOption.h"
#import "WRLDMenuChild.h"
#import "WRLDMenuTableSectionViewModel.h"

typedef NSMutableArray<WRLDMenuTableSectionViewModel *> TableSectionViewModelCollection;

@implementation WRLDSearchMenuViewController
{
    WRLDSearchMenuModel* m_menuModel;
    UIView* m_visibilityView;
    UILabel* m_titleLabel;
    UITableView * m_tableView;
    NSLayoutConstraint * m_heightConstraint;
    TableSectionViewModelCollection* m_sectionViewModels;
    
    NSString* m_menuGroupTitleTableViewCellStyleIdentifier;
    NSString* m_menuOptionTableViewCellStyleIdentifier;
    NSString* m_menuChildTableViewCellStyleIdentifier;
}

- (instancetype)initWithMenuModel:(WRLDSearchMenuModel *)menuModel
                   visibilityView:(UIView *)visibilityView
                       titleLabel:(UILabel *)titleLabel
                        tableView:(UITableView *)tableView
                 heightConstraint:(NSLayoutConstraint *)heightConstraint
{
    self = [super init];
    if (self)
    {
        m_menuModel = menuModel;
        m_visibilityView = visibilityView;
        m_titleLabel = titleLabel;
        m_tableView = tableView;
        m_heightConstraint = heightConstraint;
        
        m_menuGroupTitleTableViewCellStyleIdentifier = @"WRLDMenuGroupTitleTableViewCell";
        m_menuOptionTableViewCellStyleIdentifier = @"WRLDMenuOptionTableViewCell";
        m_menuChildTableViewCellStyleIdentifier = @"WRLDMenuChildTableViewCell";
        
        [m_menuModel setListener:self];
        
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        
        m_sectionViewModels = [[TableSectionViewModelCollection alloc] init];
        [self updateSectionViewModels];
        
        [self assignCellResourcesTo:m_tableView];
        
        [self updateTitleLabelText];
        [self resizeMenuTable];
    }
    
    return self;
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
}

- (void)updateTitleLabelText
{
    m_titleLabel.text = m_menuModel.title;
}

- (void)updateSectionViewModels
{
    [m_sectionViewModels removeAllObjects];
    
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

- (void)resizeMenuTable
{
    const CGFloat menuHeaderHeight = 44;
    CGFloat height = menuHeaderHeight;
    
    const int cellHeight = 32;
    for (WRLDMenuTableSectionViewModel* sectionViewModel in m_sectionViewModels)
    {
        height += cellHeight;
        if (sectionViewModel.expandedState == Expanded)
        {
            height += ([sectionViewModel getChildCount]) * cellHeight;
        }
    }
    
    // Account for group separator height
    NSUInteger menuGroupCount = [[m_menuModel getGroups] count];
    if (menuGroupCount > 0)
    {
        height += (menuGroupCount - 1) * 4;
    }
    
    m_heightConstraint.constant = height;
    [m_visibilityView layoutIfNeeded];
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

- (void)collapseAllSections
{
    for (WRLDMenuTableSectionViewModel* sectionViewModel in m_sectionViewModels)
    {
        [sectionViewModel setExpandedState:Collapsed];
    }
}

#pragma mark - WRLDViewVisibilityController

- (void)show
{
    if (!m_visibilityView.hidden)
    {
        return;
    }
    
    m_visibilityView.hidden = NO;
}

- (void)hide
{
    if (m_visibilityView.hidden)
    {
        return;
    }
    
    m_visibilityView.hidden =  YES;
}

#pragma mark - WRLDMenuChangedListener

- (void)onMenuTitleChanged
{
    [self updateTitleLabelText];
}

- (void)onMenuChanged
{
    [self updateSectionViewModels];
    [self resizeMenuTable];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getIdentifierForCellAtPosition:indexPath];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
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
            
            [groupTitleCell populateWith:[sectionViewModel getText]
                     isFirstTableSection:isFirstTableSection
                     isLastOptionInGroup:[sectionViewModel isLastOptionInGroup]];
            return;
        }
        
        WRLDMenuOptionTableViewCell* optionCell = (WRLDMenuOptionTableViewCell *)cell;
        if ([sectionViewModel isExpandable])
        {
            BOOL isExpanded = sectionViewModel.expandedState == Expanded;
            [optionCell populateWith:[sectionViewModel getText]
                         andExpander:isExpanded
                isFirstOptionInGroup:[sectionViewModel isFirstOptionInGroup]
             isLastOptionInGroup:[sectionViewModel isLastOptionInGroup]];
        }
        else
        {
            [optionCell populateWith:[sectionViewModel getText]
                isFirstOptionInGroup:[sectionViewModel isFirstOptionInGroup]
                 isLastOptionInGroup:[sectionViewModel isLastOptionInGroup]];
        }
        return;
    }
    
    NSUInteger childIndex = row - 1;
    WRLDMenuChild* menuChild = [sectionViewModel getChildAtIndex:childIndex];
    WRLDMenuChildTableViewCell* childCell = (WRLDMenuChildTableViewCell *)cell;
    BOOL isFirstChild = childIndex == 0;
    BOOL isLastChild = childIndex == [sectionViewModel getChildCount] - 1;
    [childCell populateWith:menuChild.text
                       icon:nil
               isFirstChild:isFirstChild
                isLastchild:isLastChild];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bool isFirstTableSection = [indexPath section] == 0;
    if (!isFirstTableSection && [indexPath row] == 0)
    {
        WRLDMenuTableSectionViewModel* sectionViewModel = [m_sectionViewModels objectAtIndex:[indexPath section]];
        if ([sectionViewModel isFirstOptionInGroup])
        {
            return 36;
        }
    }
    
    return 32;
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
    
    if ([indexPath row] == 0 && [sectionViewModel isExpandable])
    {
        ExpandedStateType currentExpandedState = sectionViewModel.expandedState;
        
        [self collapseAllSections];
        if (currentExpandedState == Collapsed)
        {
            [sectionViewModel setExpandedState:Expanded];
        }
        
        [m_tableView reloadData];
        [self resizeMenuTable];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // TODO
    //[self applyGradient: [self getGradientState:scrollView]];
}

@end
