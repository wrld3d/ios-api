#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchWidgetResultSetViewModel;

@interface WRLDMoreResultsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moreResultsLabel;
- (void) populateWith: (WRLDSearchWidgetResultSetViewModel*) resultsViewModel;
@end
