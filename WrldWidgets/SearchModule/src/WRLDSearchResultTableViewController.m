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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"genericSearchResultCell"];
    
    if(cell == nil)
    {
        NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchResultTableViewCell class]];
        
        [tableView registerNib:[UINib nibWithNibName:@"GenericSearchResult" bundle:widgetsBundle] forCellReuseIdentifier:@"genericSearchResultCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"genericSearchResultCell" forIndexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO Handle casting propertly
    WRLDSearchResultTableViewCell* castCell = (WRLDSearchResultTableViewCell*)cell;
    
    NSInteger set = [indexPath section];
    WRLDSearchResult *result = [m_resultSets[set] getResult: [indexPath row]];
    [castCell.titleLabel setText:[result title]];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberOfRowsInSection %d: %d", section, [m_resultSets[section] getResultCount]);
    return [m_resultSets[section] getResultCount];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView %d", [m_resultSets count]);
    return [m_resultSets count];
}

-(void) updateResults
{
    NSLog(@"updateResults");
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
    return 73;
}

-(void) setHeightConstraint:(NSLayoutConstraint *)heightConstraint
{
    m_heightConstraint = heightConstraint;
}

@end
