#pragma once

@protocol OnSuggestionsReceivedDelegate <NSObject>

-(void) addSuggestions: (NSMutableArray<SearchResult*>*) searchResults;
-(void) clearSuggestions;

@end

