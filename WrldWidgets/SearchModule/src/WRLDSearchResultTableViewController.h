#pragma once
#import <UIKit/UIKit.h>
#import "WRLDSearchQuery.h"

@class SearchProviders;

@interface WRLDSearchResultTableViewController : NSObject <UITableViewDataSource, UITableViewDelegate, WRLDSearchQueryCompleteDelegate>
typedef void (^ ResultSelectedCallback)(WRLDSearchResult *);
-(instancetype) init : (UIView *) tableViewContainer : (UITableView *) tableView :(SearchProviders *) searchProviders :(ResultSelectedCallback)callback;
-(void) setCurrentQuery: (WRLDSearchQuery *) currentQuery;
-(void) setHeightConstraint:(NSLayoutConstraint *)heightConstraint
                  maxHeight:(NSInteger) maxHeight;
-(void) fadeOut;

typedef NS_ENUM(NSInteger, GradientState) {
    None,
    Top,
    Bottom,
    TopAndBottom
};
@end
