#pragma once

#include "WRLDSearchPartialResponseDelegate.h"
#include "WRLDSearchResultsReadyDelegate.h"

@interface WRLDSearchPartialResponseDelegate : NSObject<WRLDSearchResultsReadyDelegate>
-(instancetype) initWithProvider: (WRLDSearchProviderReference *) provider forFullQuery:(WRLDSearchQueryAcrossMultipleProviders *) query;
@end



