#pragma once

#import <UIKit/UIKit.h>

@interface WRLDMenuOptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *expanderImage;

@property (weak, nonatomic) IBOutlet UIView *groupSeparator;

@property (weak, nonatomic) IBOutlet UIView *separator;

- (void)populateWith:(NSString *)text
isFirstOptionInGroup:(BOOL)isfirstOptionInGroup
 isLastOptionInGroup:(BOOL)isLastoptionInGroup;

- (void)populateWith:(NSString *)text
         andExpander:(BOOL)expanded
isFirstOptionInGroup:(BOOL)isfirstOptionInGroup
 isLastOptionInGroup:(BOOL)isLastoptionInGroup;

@end
