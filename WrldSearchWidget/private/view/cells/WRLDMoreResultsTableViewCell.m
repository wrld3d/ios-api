#import <Foundation/Foundation.h>
#import "WRLDMoreResultsTableViewCell.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDMoreResultsTableViewCell

- (void) populateWith: (NSString*) text icon: (UIImage *) icon
{
    self.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    self.label.text = text;
    [self.icon setImage:icon];
}

- (void) applyStyle: (WRLDSearchWidgetStyle *) style
{
    self.label.textColor = [style colorForStyle: WRLDSearchWidgetStyleMenuIconColor];
}

@end
