#import "WRLDMenuGroupTitleTableViewCell.h"

@implementation WRLDMenuGroupTitleTableViewCell

- (void)populateWith:(NSString *)text
 isFirstTableSection:(bool)isFirstTableSection
 isLastOptionInGroup:(bool)isLastOptionInGroup
{
    self.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    self.label.text = text;
    
    [self.groupSeparator setHidden:isFirstTableSection];
    [self.separator setHidden:isLastOptionInGroup];
}

@end
