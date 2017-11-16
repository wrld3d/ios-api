// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>

@class SearchProvider;

@interface WRLDSearchModule : UIViewController <UITableViewDataSource>


- (void) addSearchProvider: (SearchProvider*) searchProvider;

@end
