#import "WRLDSearchMenuViewController.h"
#import "WRLDSearchMenuModel.h"
#import "WRLDMenuGroupTitleTableViewCell.h"
#import "WRLDMenuOptionTableViewCell.h"
#import "WRLDMenuGroup.h"
#import "WRLDMenuOption.h"

@implementation WRLDSearchMenuViewController
{
    WRLDSearchMenuModel* m_menuModel;
    UIView* m_visibilityView;
    UILabel* m_titleLabel;
    UITableView * m_tableView;
    NSLayoutConstraint * m_heightConstraint;
    
    NSString* m_menuGroupTitleTableViewCellStyleIdentifier;
    NSString* m_menuOptionTableViewCellStyleIdentifier;
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
        
        [m_menuModel setListener:self];
        
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        
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
}

- (void)updateTitleLabelText
{
    m_titleLabel.text = m_menuModel.title;
}

- (void)resizeMenuTable
{
    CGFloat height = 0;
    
    for (WRLDMenuGroup* menuGroup in [m_menuModel getGroups])
    {
        const int cellHeight = 32;
        height += [[menuGroup getOptions] count] * cellHeight;
        
        if ([menuGroup hasTitle])
        {
            height += cellHeight;
        }
    }
    
    m_heightConstraint.constant = height;
    [m_tableView layoutIfNeeded];
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
    [self resizeMenuTable];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDMenuGroup* menuGroup = [[m_menuModel getGroups] objectAtIndex:[indexPath section]];
    
    NSString* cellIdentifier = m_menuOptionTableViewCellStyleIdentifier;
    NSInteger row = [indexPath row];
    if ([menuGroup hasTitle] && row == 0)
    {
        cellIdentifier = m_menuGroupTitleTableViewCellStyleIdentifier;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[m_menuModel getGroups] count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    WRLDMenuGroup* menuGroup = [[m_menuModel getGroups] objectAtIndex:section];
    NSInteger count = [[menuGroup getOptions] count];
    if ([menuGroup hasTitle])
    {
        ++count;
    }
    return count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDMenuGroup* menuGroup = [[m_menuModel getGroups] objectAtIndex:[indexPath section]];
    
    NSInteger row = [indexPath row];
    if ([menuGroup hasTitle])
    {
        --row;
    }
    
    NSString* text;
    if (row < 0)
    {
        text = menuGroup.title;
        
        WRLDMenuGroupTitleTableViewCell* optionCell = (WRLDMenuGroupTitleTableViewCell *) cell;
        [optionCell populateWith: text];
    }
    else
    {
        WRLDMenuOption* menuOption = [[menuGroup getOptions] objectAtIndex:row];
        text = menuOption.text;
        
        WRLDMenuOptionTableViewCell* optionCell = (WRLDMenuOptionTableViewCell *) cell;
        [optionCell populateWith: text];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // TODO
    //[self applyGradient: [self getGradientState:scrollView]];
}

@end
