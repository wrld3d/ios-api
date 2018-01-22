#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchDelegate.h"

@protocol WRLDSearchProvider;

@interface SearchProviders : NSObject<WRLDSearchDelegate>
-(void) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
@end
