#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchWidgetResultSetViewModel;

@interface WRLDMoreResultsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
- (void) populateWith: (NSString*) text icon: (UIImage *) icon;
@end
