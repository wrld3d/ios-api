#pragma once
#import <UIKit/UIKit.h>
#import "WRLDSearchQuery.h"

@class WRLDSearchResultSet;
@class SearchProviders;

@interface WRLDSearchResultTableViewController : NSObject <UITableViewDataSource, UITableViewDelegate, WRLDSearchQueryCompleteDelegate>
-(WRLDSearchResultTableViewController *) init : (UIView *) tableViewContainer : (UITableView *) tableView :(SearchProviders *) searchProviders;
-(void) setCurrentQuery: (WRLDSearchQuery *) currentQuery;
-(void) setHeightConstraint: (NSLayoutConstraint *) heightConstraint;

typedef NS_ENUM(NSInteger, GradientState) {
    None,
    Top,
    Bottom,
    TopAndBottom
};
@end
