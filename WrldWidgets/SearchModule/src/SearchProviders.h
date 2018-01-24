#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchDelegate.h"

@class WRLDSearchResultSet;

@protocol WRLDSearchProvider;

@interface SearchProviders : NSObject<WRLDSearchDelegate>
-(void) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
-(NSString *) getCellIdentifierForSetAtIndex:(NSInteger) index;
-(CGFloat) getCellExpectedHeightForSetAtIndex:(NSInteger) index;

-(NSInteger) count;
-(NSInteger) getIndexOfProvider: (id<WRLDSearchProvider>) provider;

@end
