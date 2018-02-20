#pragma once

#import <UIKit/UIKit.h>

@class WRLDControlStateColorMap;

@interface WRLDSearchBar : UISearchBar
-(void) setActive:(BOOL) isActive;
- (void) setActiveBorderColor: (UIColor *) color;
- (void) setInactiveBorderColor: (UIColor *) color;
@end


