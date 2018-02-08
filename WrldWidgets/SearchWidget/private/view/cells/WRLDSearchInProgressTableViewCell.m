#import "WRLDSearchInProgressTableViewCell.h"

@implementation WRLDSearchInProgressTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.spinner startAnimating];
}

@end
