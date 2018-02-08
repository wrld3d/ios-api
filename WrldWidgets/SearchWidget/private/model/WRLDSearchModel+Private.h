#pragma once

#include "WRLDSearchModel.h"

@protocol WRLDSearchQuery;

@interface WRLDSearchModel (Private)

-(WRLDSearchQuery *) buildSearchQueryFor: (NSString *) queryString;
-(WRLDSearchQuery *) buildSuggestionsQueryFor: (NSString *) queryString;

@end

