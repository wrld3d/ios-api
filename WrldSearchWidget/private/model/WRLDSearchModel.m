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
    WRLDSearchQuery * m_currentQuery;
    BOOL m_isCurrentQueryForSearch;
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
        m_currentQuery = nil;
        m_isCurrentQueryForSearch = NO;
        
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

-(void) getSearchResultsForString:(NSString *)queryString
{
    [self cancelCurrentQuery];
    m_currentQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString
                                              clearResultsOnStart: YES
                                                    queryObserver: self.searchObserver];
    [m_currentQuery dispatchRequestsToSearchProviders: m_searchProviders];
    m_isCurrentQueryForSearch = YES;
}

-(void) getSearchResultsForString:(NSString *)queryString withContext:(id<NSObject>)context
{
    [self cancelCurrentQuery];
    m_currentQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString
                                                     queryContext: context
                                              clearResultsOnStart: YES
                                                    queryObserver: self.searchObserver];
    [m_currentQuery dispatchRequestsToSearchProviders: m_searchProviders];
    m_isCurrentQueryForSearch = YES;
}


-(void) getSearchResultsForString:(NSString *)queryString clearCurrentResults: (BOOL) clearCurrentResults
{
    [self cancelCurrentQuery];
    m_currentQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString
                                              clearResultsOnStart: clearCurrentResults
                                                    queryObserver: self.searchObserver];
    [m_currentQuery dispatchRequestsToSearchProviders: m_searchProviders];
    m_isCurrentQueryForSearch = YES;
}

-(void) getSearchResultsForString:(NSString *)queryString withContext:(id<NSObject>)context clearCurrentResults: (BOOL) clearCurrentResults
{
    [self cancelCurrentQuery];
    m_currentQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString
                                                     queryContext: context
                                              clearResultsOnStart: clearCurrentResults
                                                    queryObserver: self.searchObserver];
    [m_currentQuery dispatchRequestsToSearchProviders: m_searchProviders];
    m_isCurrentQueryForSearch = YES;
}

-(void) getSuggestionsForString:(NSString *)queryString
{
    [self cancelCurrentQuery];
    m_currentQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString
                                              clearResultsOnStart: NO
                                                    queryObserver: self.suggestionObserver];
    [m_currentQuery dispatchRequestsToSuggestionProviders: m_suggestionProviders];
}

- (void)cancelCurrentQuery
{
    [m_currentQuery cancel];
    m_currentQuery = nil;
    m_isCurrentQueryForSearch = NO;
}

- (WRLDSearchQuery *)getCurrentQuery
{
    return m_currentQuery;
}

- (BOOL)isCurrentQueryForSearch
{
    return m_isCurrentQueryForSearch;
}

@end
