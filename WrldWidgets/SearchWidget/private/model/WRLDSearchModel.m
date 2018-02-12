#import "WRLDSearchModel+Private.h"
#import "WRLDSearchProviderHandle+Private.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProviderHandle+Private.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDMultipleProviderQuery.h"

@implementation WRLDSearchModel
{
    NSMutableArray<WRLDSearchProviderHandle*> * m_searchProviders;
    NSMutableArray<WRLDSuggestionProviderHandle*> * m_suggestionProviders;
}

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        m_searchProviders = [[NSMutableArray<WRLDSearchProviderHandle*> alloc] init];
        m_suggestionProviders = [[NSMutableArray<WRLDSuggestionProviderHandle*> alloc] init];
    }
    
    return self;
}

-(WRLDSearchProviderHandle *) addSearchProvider: (id<WRLDSearchProvider>) searchProvider
{
    WRLDSearchProviderHandle * reference = [[WRLDSearchProviderHandle alloc] initWithProvider: searchProvider];
    [m_searchProviders addObject:reference];
    return reference;
}

-(WRLDSuggestionProviderHandle *) addSuggestionProvider: (id<WRLDSuggestionProvider>) suggestionProvider
{
    WRLDSuggestionProviderHandle * reference = [[WRLDSuggestionProviderHandle alloc] initWithProvider: suggestionProvider];
    [m_suggestionProviders addObject:reference];
    return reference;
}

-(void) removeSearchProvider:(WRLDSearchProviderHandle *)searchProviderHandle
{
    [m_searchProviders removeObject:searchProviderHandle];
}

-(void) removeSuggestionProvider:(WRLDSuggestionProviderHandle *)suggestionProviderHandle
{
    [m_suggestionProviders removeObject:suggestionProviderHandle];
}

-(WRLDSearchQuery *) getSearchResultsForString:(NSString *)queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>)resultsDelegate
{
    WRLDMultipleProviderQuery* fullQuery = [[WRLDMultipleProviderQuery alloc] initWithQuery: queryString
                                                                         forSearchProviders: m_searchProviders
                                                                        callingOnCompletion:resultsDelegate];
    return fullQuery;
}

-(WRLDSearchQuery *) getSuggestionsForString:(NSString *)queryString withResultsDelegate:(id<WRLDSearchResultsReadyDelegate>)resultsDelegate
{
    WRLDMultipleProviderQuery* fullQuery = [[WRLDMultipleProviderQuery alloc] initWithQuery: queryString
                                                                     forSuggestionProviders: m_suggestionProviders
                                                                        callingOnCompletion:resultsDelegate];
    return fullQuery;
}

@end
