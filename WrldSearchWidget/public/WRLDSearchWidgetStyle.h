#pragma once

#import <UIKit/UIKit.h>

@interface WRLDSearchWidgetStyle : NSObject

typedef NS_ENUM(NSInteger, WRLDSearchWidgetStyleType)
{
    WRLDSearchWidgetStylePrimaryColor,
    WRLDSearchWidgetStyleSecondaryColor,
    WRLDSearchWidgetStyleSearchboxColor,
    WRLDSearchWidgetStyleResultBackgroundColor,
    WRLDSearchWidgetStyleTextPrimaryColor,
    WRLDSearchWidgetStyleTextSecondaryColor,
    WRLDSearchWidgetStyleLinkColor,
    WRLDSearchWidgetStyleWarningColor,
    WRLDSearchWidgetStyleDividerMinorColor,
    WRLDSearchWidgetStyleDividerMajorColor,
    WRLDSearchWidgetStyleScrollbarColor,
    WRLDSearchWidgetStyleMenuGroupCollapsedColor,
    WRLDSearchWidgetStyleMenuGroupExpandedColor,
    WrldSearchWidgetOfStyles
};

typedef void (^ApplyColorEvent) (UIColor * color);

- (void) usesColor: (UIColor *) color forStyle: (WRLDSearchWidgetStyleType) style ;

- (void) call: (ApplyColorEvent) event whenUpdated: (WRLDSearchWidgetStyleType) style;

- (void) apply;

@end
