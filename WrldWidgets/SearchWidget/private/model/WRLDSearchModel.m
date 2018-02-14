#import "WRLDSearchModel.h"
#import "WRLDSearchProviderHandle+Private.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProviderHandle+Private.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchQuery+Private.h"
#import "WRLDSearchModelQueryDelegate.h"

@implementation WRLDSearchModel
{
    WRLDSearchRequestFulfillerCollection * m_searchProviders;
    WRLDSearchRequestFulfillerCollection * m_suggestionProviders;
    NSInteger m_providerIdGeneration;
}

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        m_searchProviders = [[WRLDSearchRequestFulfillerCollection alloc] init];
        m_suggestionProviders = [[WRLDSearchRequestFulfillerCollection alloc] init];
        _searchDelegate = [[WRLDSearchModelQueryDelegate alloc] init];
        _suggestionDelegate = [[WRLDSearchModelQueryDelegate alloc] init];
        m_providerIdGeneration = 0;
    }
    
    return self;
}

-(WRLDSearchProviderHandle *) addSearchProvider: (id<WRLDSearchProvider>) searchProvider
{
    WRLDSearchProviderHandle * reference = [[WRLDSearchProviderHandle alloc] initWithId:[self generateUniqueProviderId] forProvider: searchProvider];
    [m_searchProviders addObject:reference];
    return reference;
}

- (NSInteger) generateUniqueProviderId
{
    ++m_providerIdGeneration;
    return m_providerIdGeneration;
}

-(WRLDSuggestionProviderHandle *) addSuggestionProvider: (id<WRLDSuggestionProvider>) suggestionProvider
{
    WRLDSuggestionProviderHandle * reference = [[WRLDSuggestionProviderHandle alloc] initWithId:[self generateUniqueProviderId] forProvider: suggestionProvider];
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

-(WRLDSearchQuery *) getSearchResultsForString:(NSString *)queryString
{
    WRLDSearchQuery* query = [[WRLDSearchQuery alloc] initWithQueryString: queryString queryDelegate: self.searchDelegate];
    [query dispatchRequestsToSearchProviders: m_searchProviders];
    return query;
}

-(WRLDSearchQuery *) getSuggestionsForString:(NSString *)queryString
{
    WRLDSearchQuery* query = [[WRLDSearchQuery alloc] initWithQueryString: queryString queryDelegate: self.suggestionDelegate];
    [query dispatchRequestsToSuggestionProviders: m_suggestionProviders];
    return query;
}

@end
