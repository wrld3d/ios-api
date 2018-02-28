#pragma once

#import <UIKit/UIKit.h>

@interface WRLDMenuGroupTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)populateWith:(NSString *)text;

@end
