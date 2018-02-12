#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchProvider;
@protocol WRLDSuggestionProvider;
@protocol WRLDSearchResultsReadyDelegate;
@class WRLDSearchProviderHandle;
@class WRLDSuggestionProviderHandle;
@class WRLDSearchQuery;

@interface WRLDSearchModel : NSObject
-(WRLDSearchProviderHandle *) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
-(WRLDSuggestionProviderHandle *) addSuggestionProvider :(id<WRLDSuggestionProvider>) suggestionProvider;

-(void) removeSearchProvider :(WRLDSearchProviderHandle *) searchProviderHandle;
-(void) removeSuggestionProvider :(WRLDSuggestionProviderHandle *) suggestionProviderHandle;

-(WRLDSearchQuery *) getSearchResultsForString:(NSString *) queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>) resultsDelegate;
-(WRLDSearchQuery *) getSuggestionsForString:(NSString *) queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>) resultsDelegate;
@end

