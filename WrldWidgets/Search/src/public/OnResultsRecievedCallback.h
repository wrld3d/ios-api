#pragma once

#import "SearchResult.h"

@interface OnResultsRecievedCallback : NSObject

-(void)onResultsRecieved: (NSMutableArray<SearchResult*>*) searchResults;

@end

