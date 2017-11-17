// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>
#import "OnResultsModelUpdateDelegate.h"
@protocol SuggestionProvider;
@protocol SearchProvider;

@interface WRLDSearchModule : UIViewController <UITableViewDataSource, OnResultsModelUpdateDelegate>

- (void) addSearchProvider: (id<SearchProvider>) searchProvider;

- (void) addSuggestionProvider: (id<SuggestionProvider>) suggestionProvider;

- (void) doSearch: (NSString*) query;

- (void) doAutoCompleteQuery: (NSString*) query;

- (void)addUpdateDelegate: (id<OnResultsModelUpdateDelegate>) delegate;

@end
