#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchQuery;
@protocol WRLDSearchRequestFulfillerHandle;

@interface WRLDSearchWidgetTableViewController : NSObject<UITableViewDataSource, UITableViewDelegate>
- (instancetype) initWithTableView: (UITableView *) tableView defaultCellIdentifier: (NSString *) defaultCellIdentifier heightConstraint: (NSLayoutConstraint *) heightConstraint;
- (void) showQuery: (WRLDSearchQuery *) query;
- (void) displayResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider;
- (void) stopDisplayingResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider;
@end


