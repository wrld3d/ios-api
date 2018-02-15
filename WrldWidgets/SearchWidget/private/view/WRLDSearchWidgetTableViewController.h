#pragma once

#import <UIKit/UIKit.h>
#import "WRLDViewVisibilityController.h"

@class WRLDSearchQuery;
@protocol WRLDSearchRequestFulfillerHandle;

@interface WRLDSearchWidgetTableViewController : NSObject<UITableViewDataSource, UITableViewDelegate, WRLDViewVisibilityController>
- (instancetype) initWithTableView: (UITableView *) tableView
                    visibilityView: (UIView*) visibilityView
                  heightConstraint: (NSLayoutConstraint *) heightConstraint
             defaultCellIdentifier: (NSString *) defaultCellIdentifier;

- (void) showQuery: (WRLDSearchQuery *) query;
- (void) displayResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider;
- (void) stopDisplayingResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider;
- (void) show;
- (void) hide;
@end


