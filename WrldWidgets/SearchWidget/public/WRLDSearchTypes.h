#pragma once

@class WRLDSearchProviderHandle;
@class WRLDSuggestionProviderHandle;
@protocol WRLDSearchResultModel;

typedef NSArray<WRLDSearchProviderHandle *> WRLDSearchProviderCollection;
typedef NSArray<WRLDSuggestionProviderHandle *> WRLDSuggestionProviderCollection;
typedef NSArray<id<WRLDSearchResultModel>> WRLDSearchResultsCollection;
