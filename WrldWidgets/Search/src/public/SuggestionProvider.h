//
//  SuggestionProvider.h
//  ios-sdk
//
//  Created by Sam Ainsworth on 10/11/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//
#pragma once

#import "SearchProvider.h"

@protocol SuggestionProvider <SearchProvider>

-(void)getSuggestions: (NSString*) query;

-(void)addOnSuggestionsRecievedCallback: (OnResultsRecievedCallback*) resultsReceivedCallback;

-(void)setSuggestionViewFactory: (SearchResultViewFactory*) searchResultFactory;

-(SearchResultViewFactory*)getSuggestionViewFactory;

@end

