#import <Foundation/Foundation.h>

#import "WRLDPoiSearchResult.h"
#import "WRLDPoiSearchResponse.h"
#import "POIServiceSearchProvider.h"

#import "WRLDSearchProviderDelegate.h"
#import "WRLDSearchResult.h"

@implementation POIServiceSearchProvider
{
    WRLDPoiService* m_poiService;
    WRLDMapView* m_mapView;
    
    int m_poiSearchId;
    WRLDSearchResultType m_searchType;
}

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService
{
    if (self = [super init])
    {
        m_mapView = mapView;
        m_poiService = poiService;
        m_poiSearchId = 0;
        m_searchType = WRLDResult;
        
        [m_mapView setPoiSearchCompletedDelegate: self];
    }
    
    return self;
}

//Called by the WRLDMapViewDelegate to receive POI search results
-(void)poiSearchDidComplete:(int)poiSearchId poiSearchResponse:(WRLDPoiSearchResponse *)poiSearchResponse
{
    if(m_poiSearchId != poiSearchId)
        return;
    
    // Unpack search results, fill structures up
    NSMutableArray<WRLDSearchResult*>* searchResultSet = [[NSMutableArray<WRLDSearchResult*> alloc] init];

    if(![poiSearchResponse succeeded])
    {
        [searchResultSet addObject: [self createSearchResult: @"Failed to get poi service results" latLng: [m_mapView centerCoordinate] subTitle:@""]];
    }
    else if([[poiSearchResponse results] count] == 0)
    {
        [searchResultSet addObject: [self createSearchResult: @"No results found" latLng: [m_mapView centerCoordinate] subTitle:@""]];
    }
    else
    {
        for(WRLDPoiSearchResult *poiSearchResult in [poiSearchResponse results])
        {
            // Add to result set
            [searchResultSet addObject: [self createSearchResult: [poiSearchResult title] latLng: [poiSearchResult latLng] subTitle:[poiSearchResult subtitle]]];
        }
    }
    
    [self clearResults];
    [self addResults:searchResultSet];

}

- (WRLDSearchResult*) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng subTitle: (NSString*)subTitle
{
    WRLDSearchResult* searchResult = [[WRLDSearchResult alloc] init];
    [searchResult setTitle: title];
    [searchResult setLatLng: latLng];
    [searchResult setSubTitle: @"Autocomplete Suggestion"];
    [searchResult setType:m_searchType];
    return searchResult;
}

- (void) search: (NSString*) query
{
    [self clearResults];
    
    WRLDTextSearchOptions* textSearchOptions = [[WRLDTextSearchOptions alloc] init];
    [textSearchOptions setQuery: query];
    [textSearchOptions setCenter:  [m_mapView centerCoordinate]];
    m_poiSearchId = [[m_poiService searchText: textSearchOptions] poiSearchId];
    m_searchType = WRLDResult;
}

- (void) searchSuggestions: (NSString*) query
{
    [self clearResults];
    
    WRLDAutocompleteOptions* autocompleteOptions = [[WRLDAutocompleteOptions alloc] init];
    [autocompleteOptions setQuery: query];
    [autocompleteOptions setCenter:  [m_mapView centerCoordinate]];
    m_poiSearchId = [[m_poiService searchAutocomplete: autocompleteOptions] poiSearchId];
    m_searchType = WRLDSuggestion;
}

@synthesize title;

@end

