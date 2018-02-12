#pragma once

#include "WRLDSearchProviderHandle.h"

@protocol WRLDSearchProvider;

@interface WRLDSearchProviderHandle (Private)

-(instancetype) initWithProvider: (id<WRLDSearchProvider>) searchProvider;

@end

