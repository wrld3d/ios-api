#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchProviderDelegate.h"
#import "WRLDSearchModuleDelegate.h"

@protocol WRLDSearchProvider;

@interface WRLDSearchModule : UIViewController <UITableViewDataSource, UITableViewDelegate, WRLDSearchModuleDelegate>

- (void) addSearchProvider: (id<WRLDSearchProvider>) searchProvider;

- (void) search: (NSString*) query;

- (void) searchSuggestions: (NSString*) query;

- (void) addSearchModuleDelegate: (id<WRLDSearchModuleDelegate>) searchModuleDelegate;

@end
