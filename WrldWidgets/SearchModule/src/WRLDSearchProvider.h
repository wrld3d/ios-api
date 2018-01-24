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

@end
