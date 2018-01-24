#pragma once
#import <UIKit/UIKit.h>
#import "WRLDSearchResultsArrivedDelegate.h"

@class WRLDSearchResultSet;
@class SearchProviders;

@interface WRLDSearchResultTableViewController : NSObject <UITableViewDataSource, UITableViewDelegate, WRLDSearchResultsArrivedDelegate>
-(WRLDSearchResultTableViewController *) init : (UITableView *) tableView :(SearchProviders *) searchProviders;
-(void) addResultSet: (WRLDSearchResultSet *) resultSet;
-(void) setHeightConstraint: (NSLayoutConstraint *) heightConstraint;
@end
