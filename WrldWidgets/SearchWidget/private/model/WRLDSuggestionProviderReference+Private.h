#pragma once

#include "WRLDSuggestionProviderReference.h"

@protocol WRLDSuggestionProvider;

@interface WRLDSuggestionProviderReference (Private)

-(instancetype) initWithProvider: (id<WRLDSuggestionProvider>) suggestionProvider;

@end
