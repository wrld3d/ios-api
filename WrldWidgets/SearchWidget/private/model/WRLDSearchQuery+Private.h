#pragma once

#include "WRLDSearchQuery.h"

@protocol WRLDSearchResultsReadyDelegate;

@interface WRLDSearchQuery (Private)
-(instancetype) initWithQueryString:(NSString *)queryString
                callingOnCompletion:(id<WRLDSearchResultsReadyDelegate>) completionDelegate;
@end


