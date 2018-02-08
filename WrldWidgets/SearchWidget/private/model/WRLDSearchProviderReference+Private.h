#pragma once

#include "WRLDSearchProviderReference.h"

@protocol WRLDSearchProvider;

@interface WRLDSearchProviderReference (Private)

-(instancetype) initWithProvider: (id<WRLDSearchProvider>) searchProvider;

@end

