// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#import <Foundation/Foundation.h>


#import "WRLDPoiSearchResult.h"
#import "WRLDPoiSearchResponse.h"
#import "POIServiceSuggestionProvider.h"

#import "SuggestionProvider.h"
#import "OnResultsReceivedDelegate.h"
#import "OnSuggestionsReceivedDelegate.h"
#import "SearchResult.h"


@implementation POIServiceSuggestionProvider
{
    WRLDPoiService* m_poiService;
    WRLDMapView* m_mapView;
    
    id<OnResultsReceivedDelegate> m_resultsReceivedDelegate;
    id<OnSuggestionsReceivedDelegate> m_suggestionsReceivedDelegate;
    SearchResultViewFactory* m_searchResultViewFactory;
}

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService
{
    if (self = [super init])
    {
        m_mapView = mapView;
        m_poiService = poiService;
        
        [m_mapView setPoiSearchCompletedDelegate: self];
    }
    
    return self;
}

-(void)poiSearchDidComplete:(int)poiSearchId poiSearchResponse:(WRLDPoiSearchResponse *)poiSearchResponse
{
    // Unpack search results, fill structures up
    NSMutableArray<SearchResult*>* searchResultSet = [[NSMutableArray<SearchResult*> alloc] init];

    if([poiSearchResponse succeeded])
    {
        [searchResultSet addObject: [self createSearchResult: @"Failed to get poi service results" latLng: [m_mapView centerCoordinate]]];
    }
    else if([[poiSearchResponse results] count] == 0)
    {
        [searchResultSet addObject: [self createSearchResult: @"No results found" latLng: [m_mapView centerCoordinate]]];
    }
    else
    {
        for(WRLDPoiSearchResult *poiSearchResult in [poiSearchResponse results])
        {
            // Add to result set
            [searchResultSet addObject: [self createSearchResult: [poiSearchResult title] latLng: [poiSearchResult latLng]]];
        }
    }
    
    // Invoke callback
    if(m_resultsReceivedDelegate != nil)
    {
        [m_resultsReceivedDelegate clearResults];
        [m_resultsReceivedDelegate addResults: searchResultSet];
    }
    
    if(m_suggestionsReceivedDelegate != nil)
    {
        [m_suggestionsReceivedDelegate clearSuggestions];
        [m_suggestionsReceivedDelegate addSuggestions: searchResultSet];
    }
}

- (SearchResult*) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng
{
    SearchResult* searchResult = [[SearchResult alloc] init];
    [searchResult setTitle: title];
    [searchResult setLatLng: latLng];
    // todo - Set other properties
    
    return searchResult;
}

-(void)getSuggestions: (NSString*) query
{
    [self getSearchResults: query];
}

- (SearchResultViewFactory*)getSuggestionViewFactory
{
    return [self getResultViewFactory];
}

- (void)addOnSuggestionsReceivedDelegate:(id<OnSuggestionsReceivedDelegate>)suggestionsReceivedDelegate
{
    m_suggestionsReceivedDelegate = suggestionsReceivedDelegate;
}

- (void)setSuggestionViewFactory:(SearchResultViewFactory *)searchResultFactory
{
    [self setResultViewFactory: searchResultFactory];
}

- (void)getSearchResults:(NSString *)query
{
    WRLDAutocompleteOptions* autocompleteOptions = [[WRLDAutocompleteOptions alloc] init];
    [autocompleteOptions setQuery: query];
    [autocompleteOptions setCenter:  [m_mapView centerCoordinate]];
    [m_poiService searchAutocomplete: autocompleteOptions];
}

- (void)addOnResultsReceivedDelegate:(id<OnResultsReceivedDelegate>)resultsReceivedDelegate
{
    m_resultsReceivedDelegate = resultsReceivedDelegate;
}

- (SearchResultViewFactory *)getResultViewFactory
{
    return m_searchResultViewFactory;
}


- (void)setResultViewFactory:(SearchResultViewFactory *)viewFactory
{
    m_searchResultViewFactory = viewFactory;
}


@synthesize title;

@end

