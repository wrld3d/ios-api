#import "WRLDSearchModel.h"
#import "WRLDSearchProviderHandle+Private.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProviderHandle+Private.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchQuery+Private.h"
#import "WRLDQueryDelegate.h"
#import "WRLDSearchModelQueryDelegate.h"

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
        _searchDelegate = [[WRLDSearchModelQueryDelegate alloc] init];
        _suggestionDelegate = [[WRLDSearchModelQueryDelegate alloc] init];
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
