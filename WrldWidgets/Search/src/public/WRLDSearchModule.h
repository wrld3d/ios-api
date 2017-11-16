// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>
#import "OnResultsRecievedCallback.h"
#import "SearchProvider.h"
#import "SuggestionProvider.h"

@interface WRLDSearchModule : UIViewController <UITableViewDataSource, OnResultsRecievedCallback>


- (void) addSearchProvider: (id<SearchProvider>) searchProvider;

- (void) addSuggestionProvider: (id<SuggestionProvider>) suggestionProvider;

- (void) doSearch: (NSString*) query;

- (void) doAutoCompleteQuery: (NSString*) query;

@end
