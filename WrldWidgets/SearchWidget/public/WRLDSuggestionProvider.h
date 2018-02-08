#pragma once

#import <Foundation/Foundation.h>

@class WRLDSearchQuery;
@protocol WRLDSuggestionProvider
- (void) getSuggestions: (WRLDSearchQuery *) query;
@end
