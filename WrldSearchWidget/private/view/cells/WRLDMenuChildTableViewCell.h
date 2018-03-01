#pragma once

#import <UIKit/UIKit.h>

@interface WRLDMenuChildTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIView *separator;

@property (weak, nonatomic) IBOutlet UIView *topShadow;

@property (weak, nonatomic) IBOutlet UIView *bottomShadow;

- (void)populateWith:(NSString *)text
                icon:(nullable UIImage *)icon
        isFirstChild:(BOOL)isFirstChild
         isLastchild:(BOOL)isLastChild;

@end

