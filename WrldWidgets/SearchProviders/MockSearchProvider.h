#pragma once
#include "WRLDSearchProvider.h"
#include "WRLDSuggestionProvider.h"

@import Wrld;

@interface MockSearchProvider : NSObject <WRLDSearchProvider, WRLDSuggestionProvider>
@end



