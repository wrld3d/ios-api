#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchProvider;

@interface WRLDSearchWidgetView : UIView <UISearchBarDelegate>
-(void) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
@end
