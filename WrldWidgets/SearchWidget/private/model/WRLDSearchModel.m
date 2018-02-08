#import "WRLDSearchModel+Private.h"
#import "WRLDSearchProviderReference+Private.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProviderReference+Private.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchQueryAcrossMultipleProviders.h"

@implementation WRLDSearchModel
{
    NSMutableArray<WRLDSearchProviderReference*> * m_searchProviders;
    NSMutableArray<WRLDSuggestionProviderReference*> * m_suggestionProviders;
}

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        m_searchProviders = [[NSMutableArray<WRLDSearchProviderReference*> alloc] init];
        m_suggestionProviders = [[NSMutableArray<WRLDSuggestionProviderReference*> alloc] init];
    }
    
    return self;
}

-(WRLDSearchProviderReference *) addSearchProvider: (id<WRLDSearchProvider>) searchProvider
{
    WRLDSearchProviderReference * reference = [[WRLDSearchProviderReference alloc] initWithProvider: searchProvider];
    [m_searchProviders addObject:reference];
    return reference;
}

-(WRLDSuggestionProviderReference *) addSuggestionProvider: (id<WRLDSuggestionProvider>) suggestionProvider
{
    WRLDSuggestionProviderReference * reference = [[WRLDSuggestionProviderReference alloc] initWithProvider: suggestionProvider];
    [m_suggestionProviders addObject:reference];
    return reference;
}

-(WRLDSearchQuery *) getSearchResultsForString:(NSString *)queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>)resultsDelegate
{
    WRLDSearchQueryAcrossMultipleProviders* fullQuery = [[WRLDSearchQueryAcrossMultipleProviders alloc] initWithQuery: queryString forProviders: m_searchProviders];
    return fullQuery;
}

-(WRLDSearchQuery *) getSuggestionsForString:(NSString *)queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>)resultsDelegate
{
    WRLDSearchQueryAcrossMultipleProviders* fullQuery = [[WRLDSearchQueryAcrossMultipleProviders alloc] initWithQuery: queryString forProviders: m_suggestionProviders];
    return fullQuery;
}

@end
