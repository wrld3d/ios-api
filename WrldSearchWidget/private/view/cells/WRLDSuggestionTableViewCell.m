#import "WRLDSuggestionTableViewCell.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDSuggestionTableViewCell

- (void) applyStyle: (WRLDSearchWidgetStyle *) style
{
    [super applyStyle: style];
    self.spacer.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMinorDividerColor];
}

@end

