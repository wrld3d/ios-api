#pragma once

#import <UIKit/UIKit.h>
#import "WRLDViewVisibilityController.h"

@class WRLDSearchQuery;
@protocol WRLDSearchRequestFulfillerHandle;
@class WRLDSearchResultSelectedObserver;

@interface WRLDSearchWidgetTableViewController : NSObject<UITableViewDataSource, UITableViewDelegate, WRLDViewVisibilityController>
- (instancetype) initWithTableView: (UITableView *) tableView
                    visibilityView: (UIView*) visibilityView
                  heightConstraint: (NSLayoutConstraint *) heightConstraint
             defaultCellIdentifier: (NSString *) defaultCellIdentifier;

@property (nonatomic, readonly) WRLDSearchResultSelectedObserver * selectionObserver;
@property (nonatomic, readonly) NSInteger * visibleResults;
- (void) showQuery: (WRLDSearchQuery *) query;

- (void) displayResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider
     maxToShowWhenCollapsed: (NSInteger) maxToShowWhenCollapsed
      maxToShowWhenExpanded: (NSInteger) maxToShowWhenExpanded;

- (void) stopDisplayingResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider;
- (void) show;
- (void) hide;
@end


