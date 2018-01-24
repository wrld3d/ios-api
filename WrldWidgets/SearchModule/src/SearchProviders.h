#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchDelegate.h"

@class WRLDSearchResultSet;

@protocol WRLDSearchProvider;

@interface SearchProviders : NSObject<WRLDSearchDelegate>
-(WRLDSearchResultSet *) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
-(NSString *) getCellIdentifierForSetAtIndex:(NSInteger) index;
-(CGFloat) getCellExpectedHeightForSetAtIndex:(NSInteger) index;

@end
