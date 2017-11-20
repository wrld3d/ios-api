#pragma once

#import <Foundation/Foundation.h>
#import "WRLDSearchProviderDelegate.h"

@protocol WRLDSearchProvider <NSObject>

@property (nonatomic, readonly, copy) NSString *title;

- (void) search: (NSString*) query;

- (void) searchSuggestions: (NSString*) query;

- (void) setSearchProviderDelegate: (id<WRLDSearchProviderDelegate>) searchProviderDelegate;

@end

@interface WRLDSearchProviderBase : NSObject

- (void) setSearchProviderDelegate: (id<WRLDSearchProviderDelegate>) searchProviderDelegate;

-(void) addResults: (NSMutableArray<WRLDSearchResult*>*) searchResults;

-(void) clearResults;

@end
