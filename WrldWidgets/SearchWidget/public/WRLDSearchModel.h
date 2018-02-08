#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchProvider;
@protocol WRLDSuggestionProvider;
@protocol WRLDSearchResultsReadyDelegate;
@class WRLDSearchProviderReference;
@class WRLDSuggestionProviderReference;
@class WRLDSearchQuery;

@interface WRLDSearchModel : NSObject
-(WRLDSearchProviderReference *) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
-(WRLDSuggestionProviderReference *) addSuggestionProvider :(id<WRLDSuggestionProvider>) suggestionProvider;

-(WRLDSearchQuery *) getSearchResultsForString:(NSString *) queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>) resultsDelegate;
-(WRLDSearchQuery *) getSuggestionsForString:(NSString *) queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>) resultsDelegate;
@end

