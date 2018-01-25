#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchQuery.h"

@class SearchProviders;

@interface WRLDSearchSuggestionsViewController : NSObject <UITableViewDataSource, UITableViewDelegate, WRLDSearchQueryCompleteDelegate>
-(instancetype) init : (UITableView *) tableView : (SearchProviders *) searchProviders;
-(void) setCurrentQuery: (WRLDSearchQuery *) currentQuery;
-(void) setHeightConstraint: (NSLayoutConstraint *) heightConstraint;
-(void) fadeOut;
@end

