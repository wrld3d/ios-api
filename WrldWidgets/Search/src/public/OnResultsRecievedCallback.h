#pragma once

#import "SearchResult.h"

@protocol OnResultsRecievedCallback <NSObject>

-(void)onResultsRecieved: (NSMutableArray<SearchResult*>*) searchResults;

@end

