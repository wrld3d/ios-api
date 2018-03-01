#import "WRLDMenuChildTableViewCell.h"

@implementation WRLDMenuChildTableViewCell

- (void)populateWith:(NSString *)text
                icon:(nullable UIImage *)icon
        isFirstChild:(BOOL)isFirstChild
         isLastchild:(BOOL)isLastChild
{
    self.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    self.label.text = text;
    // TODO: set icon
    //[self.icon setImage:icon];
    [self.separator setHidden:isLastChild];
    [self.topShadow setHidden:!isFirstChild];
    [self.bottomShadow setHidden:!isLastChild];
    
    if (isLastChild)
    {
        CAGradientLayer* gradient = [CAGradientLayer layer];
        gradient.frame = self.bottomShadow.bounds;
        gradient.colors = @[(id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor, (id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor];
        [self.bottomShadow.layer insertSublayer:gradient atIndex:0];
    }
    
    if (isFirstChild)
    {
        CAGradientLayer* gradient = [CAGradientLayer layer];
        gradient.frame = self.topShadow.bounds;
        gradient.colors = @[(id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor, (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor];
        [self.topShadow.layer insertSublayer:gradient atIndex:0];
    }
}

@end
