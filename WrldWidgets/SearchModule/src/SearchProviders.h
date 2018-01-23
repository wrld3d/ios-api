#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchDelegate.h"

@class WRLDSearchResultSet;

@protocol WRLDSearchProvider;

@interface SearchProviders : NSObject<WRLDSearchDelegate>
-(WRLDSearchResultSet *) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
@end
