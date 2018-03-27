#import "WRLDSearchInProgressTableViewCell.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDSearchInProgressTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.spinner startAnimating];
}

- (void) applyStyle: (WRLDSearchWidgetStyle *) style
{
    self.backgroundColor = [style colorForStyle: WRLDSearchWidgetStylePrimaryColor];
}

@end
