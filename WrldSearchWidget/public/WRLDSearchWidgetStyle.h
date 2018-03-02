#pragma once

#import <UIKit/UIKit.h>

@interface WRLDSearchWidgetStyle : NSObject

typedef NS_ENUM(NSInteger, WRLDSearchWidgetStyleType)
{
    WRLDSearchWidgetStylePrimaryColor,
    WRLDSearchWidgetStyleSecondaryColor,
    WRLDSearchWidgetStyleSearchBarColor,
    WRLDSearchWidgetStyleResultBackgroundColor,
    WRLDSearchWidgetStyleTextPrimaryColor,
    WRLDSearchWidgetStyleTextSecondaryColor,
    WRLDSearchWidgetStyleLinkColor,
    WRLDSearchWidgetStyleWarningColor,
    WRLDSearchWidgetStyleDividerMinorColor,
    WRLDSearchWidgetStyleDividerMajorColor,
    WRLDSearchWidgetStyleMenuGroupExpandedColor,
    WRLDSearchWidgetStyleMenuGroupCollapsedColor,
    WRLDSearchWidgetStyleMenuGroupTextExpandedColor,
    WRLDSearchWidgetStyleMenuGroupTextCollapsedColor,
    WRLDSearchWidgetStyleMenuIconColor,
    WrldSearchWidgetNumberOfStyles
};

typedef void (^ApplyColorEvent) (UIColor * color);

- (void) usesColor: (UIColor *) color forStyle: (WRLDSearchWidgetStyleType) style;

- (UIColor *) colorForStyle: (WRLDSearchWidgetStyleType) style;

- (void) call: (ApplyColorEvent) event toApply: (WRLDSearchWidgetStyleType) style;

- (void) apply;

@end
