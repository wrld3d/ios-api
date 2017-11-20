#pragma once

#import "WRLDSearchResult.h"

@protocol WRLDSearchModuleDelegate

- (void) dataDidChange;

- (void) didSelectResult: (WRLDSearchResult*) searchResult;

@end
