#pragma once
#import <UIKit/UIKit.h>
#import "WRLDSearchResultsArrivedDelegate.h"

@class WRLDSearchResultSet;

@interface WRLDSearchResultTableViewController : NSObject <UITableViewDataSource, UITableViewDelegate, WRLDSearchResultsArrivedDelegate>
-(WRLDSearchResultTableViewController *) init : (UITableView *) tableView;
-(void) addResultSet: (WRLDSearchResultSet *) resultSet;
-(void) setHeightConstraint: (NSLayoutConstraint *) heightConstraint;
@end
