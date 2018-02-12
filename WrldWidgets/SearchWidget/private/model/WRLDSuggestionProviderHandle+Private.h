#pragma once

#include "WRLDSuggestionProviderHandle.h"

@protocol WRLDSuggestionProvider;

@interface WRLDSuggestionProviderHandle (Private)

-(instancetype) initWithProvider: (id<WRLDSuggestionProvider>) suggestionProvider;

@end
