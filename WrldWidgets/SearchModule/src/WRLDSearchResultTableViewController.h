#pragma once
#import <UIKit/UIKit.h>
#import "WRLDSearchQuery.h"

@class SearchProviders;

@interface WRLDSearchResultTableViewController : NSObject <UITableViewDataSource, UITableViewDelegate, WRLDSearchQueryCompleteDelegate>
-(instancetype) init : (UIView *) tableViewContainer : (UITableView *) tableView :(SearchProviders *) searchProviders;
-(void) setCurrentQuery: (WRLDSearchQuery *) currentQuery;
-(void) setHeightConstraint: (NSLayoutConstraint *) heightConstraint;
-(void) fadeOut;

typedef NS_ENUM(NSInteger, GradientState) {
    None,
    Top,
    Bottom,
    TopAndBottom
};
@end
