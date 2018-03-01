#import "WRLDMenuOptionTableViewCell.h"

@implementation WRLDMenuOptionTableViewCell

- (void)populateWith:(NSString *)text
isFirstOptionInGroup:(BOOL)isFirstOptionInGroup
 isLastOptionInGroup:(BOOL)isLastoptionInGroup
{
    self.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    self.label.text = text;
    
    [self.expanderImage setHidden:YES];
    
    [self.groupSeparator setHidden:!isFirstOptionInGroup];
    [self.separator setHidden:isLastoptionInGroup];
}

- (void)populateWith:(NSString *)text
         andExpander:(BOOL)expanded
isFirstOptionInGroup:(BOOL)isFirstOptionInGroup
 isLastOptionInGroup:(BOOL)isLastoptionInGroup
{
    self.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    self.label.text = text;
    
    [self.expanderImage setHidden:NO];
    
    [self.groupSeparator setHidden:!isFirstOptionInGroup];
    [self.separator setHidden:(expanded || isLastoptionInGroup)];
    
    [UIView animateWithDuration: 0.2f animations:^{
        CGFloat degrees = expanded ? 270.0f : 0.0f;
        CGFloat radians = degrees * M_PI/180;
        self.expanderImage.transform = CGAffineTransformMakeRotation(radians);
    }];
}

@end
