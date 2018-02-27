#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchWidgetStyle;

@interface WRLDSearchInProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (void) applyStyle : (WRLDSearchWidgetStyle *) style;
@end
