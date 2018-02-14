#pragma once

#import "UIKit/UIKit.h"

#import "WRLDQueryFinishedDelegate.h"

@class WRLDSearchWidgetTableViewController;

@interface WRLDQueryFinishedViewUpdateDelegate : NSObject<WRLDQueryFinishedDelegate>

- (instancetype) initWithDisplayer: (WRLDSearchWidgetTableViewController *) queryDisplayer;
- (void) onQueryCompletionHide: (UIView *) viewToHide;

@end


