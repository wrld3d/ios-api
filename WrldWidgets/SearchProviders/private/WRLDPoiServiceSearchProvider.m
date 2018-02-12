#import <Foundation/Foundation.h>

#import "WRLDPoiSearchResult.h"
#import "WRLDPoiSearchResponse.h"
#import "WRLDPoiServiceSearchProvider.h"

#import "WRLDSearchQuery.h"
#import "WRLDPositionedSearchResultModel.h"

#import "WRLDSearchTypes.h"

@implementation WRLDPoiServiceSearchProvider
{
    WRLDPoiService* m_poiService;
    WRLDMapView* m_mapView;
    
    int m_poiSearchId;
    
    WRLDSearchQuery *m_currentQuery;
}

@synthesize title;
@synthesize cellIdentifier;

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService
{
    if (self = [super init])
    {
        m_mapView = mapView;
        m_poiService = poiService;
        m_poiSearchId = 0;
        cellIdentifier = @"WRLDSearchResultTableViewCell";
        title = @"WRLD";
        
        m_mapView.delegate = self;
    }
    
    return self;
}

//Called by the WRLDMapViewDelegate to receive POI search results
- (void)mapView:(WRLDMapView *)mapView poiSearchDidComplete: (int) poiSearchId poiSearchResponse: (WRLDPoiSearchResponse*) poiSearchResponse
{
    if(m_poiSearchId != poiSearchId)
    {
        return;
    }
    
    // Unpack search results, fill structures up
    WRLDMutableSearchResultsCollection* searchResults= [[WRLDMutableSearchResultsCollection alloc] init];
    
    if([poiSearchResponse succeeded])
    {
        for(WRLDPoiSearchResult *poiSearchResult in [poiSearchResponse results])
        {
            // Add to result set
            [searchResults addObject: [self createSearchResult: [poiSearchResult title]
                                                        latLng: [poiSearchResult latLng]
                                                      subTitle:[poiSearchResult subtitle]
                                                       iconKey:nil]];
        }
    }
    
    [m_currentQuery didComplete:[poiSearchResponse succeeded] withResults:searchResults];
}

- (id<WRLDSearchResultModel>) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng subTitle: (NSString*)subTitle iconKey:(NSString*) iconKey
{
    WRLDPositionedSearchResultModel* searchResult =
    [[WRLDPositionedSearchResultModel alloc] initWithTitle:title
                                                  subTitle:subTitle
                                                   iconKey:iconKey
                                                  latLng:latLng];

    return searchResult;
}

- (void) searchFor: (WRLDSearchQuery*) query
{
    [self cancelInFlightQuery];
    m_currentQuery = query;
    WRLDTextSearchOptions* textSearchOptions = [[WRLDTextSearchOptions alloc] init];
    [textSearchOptions setQuery: query.queryString];
    [textSearchOptions setCenter:  [m_mapView centerCoordinate]];
    m_poiSearchId = [[m_poiService searchText: textSearchOptions] poiSearchId];
}

- (void) getSuggestions: (WRLDSearchQuery*) query
{
    [self cancelInFlightQuery];
    m_currentQuery = query;
    WRLDAutocompleteOptions* autocompleteOptions = [[WRLDAutocompleteOptions alloc] init];
    [autocompleteOptions setQuery: query.queryString];
    [autocompleteOptions setCenter:  [m_mapView centerCoordinate]];
    m_poiSearchId = [[m_poiService searchAutocomplete: autocompleteOptions] poiSearchId];
}

- (void) cancelInFlightQuery
{
    if(m_currentQuery && !m_currentQuery.hasCompleted)
    {
        [m_currentQuery cancel];
    }
}

@end


