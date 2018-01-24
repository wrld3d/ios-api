#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchProvider;

@interface WRLDSearchWidgetView : UIView <UISearchBarDelegate>
-(void) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib;
@end

