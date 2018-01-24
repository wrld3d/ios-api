#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchProviderDelegate.h"

@class WRLDSearchQuery;

/// The protocol that can be implemented to provide custom search functionality
@protocol WRLDSearchProvider <NSObject>

/// The title of this search provider
@property (nonatomic, readonly, copy) NSString *title;

@property (nonatomic, readonly, copy) NSString *cellIdentifier;

@property (nonatomic, readonly) CGFloat cellExpectedHeight;

/*!
 Calling this should clear current search results and start a new search.
 
 @param query The text to search for.
 */
- (void) search: (WRLDSearchQuery *) query;

/*!
 Calling this should clear current search results and start a new suggestion search.
 
 @param query The text to provide suggestions for.
 */
- (void) searchSuggestions: (NSString*) query;

/*!
 Sets the delegate that will be called when new search result comes in. An implementation of this
 method is provided by WRLDSearchProviderBase.
 
 @param searchProviderDelegate The delegate to handle search and suggestion results.
 */
- (void) setSearchProviderDelegate: (id<WRLDSearchProviderDelegate>) searchProviderDelegate;

@end


/// A helper class that implements the delegate for the search provider.
@interface WRLDSearchProviderBase : NSObject

/*!
 Sets the delegate that will be called when new search result comes in.
 
 @param searchProviderDelegate The delegate to handle search and suggestion results.
 */
- (void) setSearchProviderDelegate: (id<WRLDSearchProviderDelegate>) searchProviderDelegate;

/*!
 This should be called by the search provider implementation to add new search results to the model.
 
 @param searchResults The search results to add to the model.
 */
-(void) addResults: (NSMutableArray<WRLDSearchResult*>*) searchResults;

/*!
 This should be called by the search provider implementation to clear search results beloning to this
 provider.
 */
-(void) clearResults;

@end
