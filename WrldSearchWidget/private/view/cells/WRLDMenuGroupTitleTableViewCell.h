#pragma once

#import <UIKit/UIKit.h>

@interface WRLDMenuGroupTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIView *groupSeparator;

@property (weak, nonatomic) IBOutlet UIView *separator;

- (void)populateWith:(NSString *)text
 isFirstTableSection:(bool)isFirstTableSection
 isLastOptionInGroup:(bool)isLastOptionInGroup;

@end
