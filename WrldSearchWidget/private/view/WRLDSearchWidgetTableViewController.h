#pragma once

#import <UIKit/UIKit.h>
#import "WRLDViewVisibilityController.h"

@class WRLDSearchQuery;
@protocol WRLDSearchRequestFulfillerHandle;
@class WRLDSearchResultSelectedObserver;
@class WRLDSearchWidgetStyle;
@class WRLDSearchWidgetResultsTableDataSource;

@interface WRLDSearchWidgetTableViewController : NSObject<UITableViewDelegate, WRLDViewVisibilityController>

- (instancetype) initWithTableView: (UITableView *) tableView
                        dataSource: (WRLDSearchWidgetResultsTableDataSource *) dataSource
                    visibilityView: (UIView*) visibilityView
                  heightConstraint: (NSLayoutConstraint *) heightConstraint
                             style: (WRLDSearchWidgetStyle *) style;

- (void) refreshTable;
- (void) show;
- (void) hide;
@end


