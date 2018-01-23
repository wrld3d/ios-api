#import <Foundation/Foundation.h>
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchResult.h"
#import "WRLDSearchResultTableViewController.h"
#import "WRLDSearchResultSet.h"

@implementation WRLDSearchResultTableViewController
{
    NSMutableArray<WRLDSearchResultSet *> *m_resultSets;
    UITableView * m_tableView;
    NSLayoutConstraint * m_heightConstraint;
}

-(WRLDSearchResultTableViewController *) init : (UITableView *) tableView
{
    self = [super init];
    m_resultSets = [[NSMutableArray<WRLDSearchResultSet *> alloc] init];
    if(self){
        m_tableView = tableView;
    }
    return self;
}

-(void) addResultSet: (WRLDSearchResultSet*)resultSet
{
    [m_resultSets addObject: resultSet];    
    [resultSet updateDelegate: self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getIdentifierForCellAtPosition: indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchResultTableViewCell class]];
        [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:widgetsBundle] forCellReuseIdentifier: cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier forIndexPath:indexPath];
    }
    
    return cell;
}

-(NSString *) getIdentifierForCellAtPosition:(NSIndexPath *) index {
    if([self isFooter:index]){
        return @"DisplayMoreResultsCell";
    }
    
    return @"GenericSearchResult";
}

-(bool) isFooter: (NSIndexPath * ) index
{
    WRLDSearchResultSet * set = m_resultSets[[index section]];
    if([set hasMoreToShow] || [set getExpandedState] == Expanded){
        return [index row] == [set getVisibleResultCount];
    }
    return false;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO Handle casting propertly
    if(![self isFooter:indexPath]){
        WRLDSearchResultTableViewCell* castCell = (WRLDSearchResultTableViewCell*)cell;
    
        WRLDSearchResult *result = [m_resultSets[[indexPath section]] getResult: [indexPath row]];
        [castCell.titleLabel setText:[result title]];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"numberOfSectionsInTableView %d", [m_resultSets count]);
    return [m_resultSets count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSInteger visibleCells = [m_resultSets[section] getVisibleResultCount];
    if([m_resultSets[section] hasMoreToShow] || [m_resultSets[section] getExpandedState] == Expanded){
        visibleCells++;
    }
        
    return visibleCells;
}

-(void) updateResults
{
    //NSLog(@"updateResults");
    [m_tableView reloadData];
    //CGRect bounds = m_tableView.bounds;
    CGFloat height = 0;
    for(int i = 0; i < [m_resultSets count]; ++i){
        for(int j = 0; j < [m_resultSets[i] getResultCount]; ++j){
            height += [self tableView:m_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
        }
    }
    
    height = MIN(400, height);
    
    //bounds.size.height = height;

    //m_tableView.bounds = bounds;
    [UIView animateWithDuration: 0.25 animations:^{
        m_heightConstraint.constant = height;
        [m_tableView layoutIfNeeded];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isFooter:indexPath]){
        return 32;
    }
    return 73;
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
        if([m_resultSets[section] getExpandedState] == Expanded)
        {
            for(int i = 0; i < [m_resultSets count]; ++i)
            {
                [m_resultSets[i] setExpandedState:Collapsed];
            }
        }
        else{
            for(int i = 0; i < [m_resultSets count]; ++i)
            {
                [m_resultSets[i] setExpandedState:(section == i) ? Expanded : Hidden];
            }
        }
        [self updateResults];
    }
}

@end
