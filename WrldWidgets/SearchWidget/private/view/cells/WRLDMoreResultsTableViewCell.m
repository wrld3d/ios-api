#import <Foundation/Foundation.h>
#import "WRLDMoreResultsTableViewCell.h"

@implementation WRLDMoreResultsTableViewCell

- (void) populateWith: (NSString*) text icon: (UIImage *) icon
{
    self.label.text = text;
    [self.icon setImage:icon];
}

@end
