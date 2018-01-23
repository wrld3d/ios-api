#import <Foundation/Foundation.h>
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchResult.h"
#import "WRLDSearchResultTableViewController.h"
#import "WRLDSearchResultSet.h"

@implementation WRLDSearchResultTableViewController
{
    NSMutableArray<WRLDSearchResultSet *> *m_resultSets;
    UITableView * m_tableView;
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
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

@end
