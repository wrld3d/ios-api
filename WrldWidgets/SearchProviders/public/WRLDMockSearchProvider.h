#pragma once
#include "WRLDSearchProvider.h"
#include "WRLDSuggestionProvider.h"

@import Wrld;

@interface WRLDMockSearchProvider : NSObject <WRLDSearchProvider, WRLDSuggestionProvider>
- (instancetype)initWithSearchDelayInSeconds:(CGFloat) searchDelayInSeconds suggestionDelayInSeconds:(CGFloat) suggestionDelayInSeconds;
@end

