#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchQuery.h"

@class SearchProviders;
@class WRLDSearchWidgetView;

@interface WRLDSearchSuggestionsViewController : NSObject <UITableViewDataSource, UITableViewDelegate, WRLDSearchQueryCompleteDelegate>
typedef void (^ SuggestionSelectedCallback)(NSString *);
-(instancetype) init : (UITableView *) tableView : (SearchProviders *) searchProviders :(SuggestionSelectedCallback)callback;
-(void) setCurrentQuery: (WRLDSearchQuery *) currentQuery;
-(void) setHeightConstraint: (NSLayoutConstraint *) heightConstraint;
-(void) fadeOut;
@end

