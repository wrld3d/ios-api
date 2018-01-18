#import <Foundation/Foundation.h>

#import "WRLDSearchModule.h"
#import "WRLDSearchResultsTableViewController.h"

@implementation WRLDSearchModule
{
    WRLDSearchResultsTableViewController * m_searchResultsTableViewController;
}

-(instancetype) init
{
    self = [super init];
    
    m_searchResultsTableViewController = [[WRLDSearchResultsTableViewController alloc] init];
    
    return self;
}

-(id<UITableViewDelegate>) getResultsTableViewDelegate
{
    return m_searchResultsTableViewController;
}

-(id<UITableViewDataSource>) getResultsTableViewDataSource
{
    return m_searchResultsTableViewController;
}

@end

