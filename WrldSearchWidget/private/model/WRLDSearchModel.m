#import "WRLDSearchModel.h"
#import "WRLDSearchProviderHandle+Private.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProviderHandle+Private.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchQuery+Private.h"
#import "WRLDSearchQueryObserver.h"

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
        _searchObserver = [[WRLDSearchQueryObserver alloc] init];
        _suggestionObserver = [[WRLDSearchQueryObserver alloc] init];
        m_providerIdGeneration = 0;
        
        [self.searchObserver addQueryStartingEvent:^(WRLDSearchQuery * query){
            _isSearchQueryInFlight = YES;}];
        [self.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery * query){
            _isSearchQueryInFlight = NO;}];
        [self.searchObserver addQueryCancelledEvent:^(WRLDSearchQuery * query){
            _isSearchQueryInFlight = NO;}];
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
    WRLDSearchQuery* query = [[WRLDSearchQuery alloc] initWithQueryString: queryString queryObserver: self.searchObserver];
    [query dispatchRequestsToSearchProviders: m_searchProviders];
    return query;
}

-(WRLDSearchQuery *) getSearchResultsForString:(NSString *)queryString withContext:(id<NSObject>)context
{
    WRLDSearchQuery* query = [[WRLDSearchQuery alloc] initWithQueryString: queryString queryContext: context queryObserver: self.searchObserver];
    [query dispatchRequestsToSearchProviders: m_searchProviders];
    return query;
}

-(WRLDSearchQuery *) getSuggestionsForString:(NSString *)queryString
{
    WRLDSearchQuery* query = [[WRLDSearchQuery alloc] initWithQueryString: queryString queryObserver: self.suggestionObserver];
    [query dispatchRequestsToSuggestionProviders: m_suggestionProviders];
    return query;
}

@end
