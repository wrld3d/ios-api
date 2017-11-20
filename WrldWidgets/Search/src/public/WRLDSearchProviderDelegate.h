#pragma once

@class WRLDSearchResult;

@protocol WRLDSearchProviderDelegate <NSObject>

-(void) addResults: (NSMutableArray<WRLDSearchResult*>*) searchResults;

-(void) clearResults;

@end

