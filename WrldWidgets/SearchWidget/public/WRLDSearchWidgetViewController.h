#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchProvider;
@protocol WRLDSuggestionProvider;

@interface WRLDSearchWidgetViewController : UIViewController <UISearchBarDelegate>
@end
