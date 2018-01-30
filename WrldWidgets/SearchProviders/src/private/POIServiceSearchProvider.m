#import <Foundation/Foundation.h>

#import "WRLDPoiSearchResult.h"
#import "WRLDPoiSearchResponse.h"
#import "POIServiceSearchProvider.h"

#import "WRLDSearchProviderDelegate.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchResult.h"

@implementation POIServiceSearchProvider
{
    WRLDPoiService* m_poiService;
    WRLDMapView* m_mapView;
    
    int m_poiSearchId;
    
    WRLDSearchQuery *m_currentQuery;
}

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService
{
    if (self = [super init])
    {
        m_mapView = mapView;
        m_poiService = poiService;
        m_poiSearchId = 0;
        cellIdentifier = @"WRLDGenericSearchResult";
        cellExpectedHeight = 64;
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
    NSMutableArray<WRLDSearchResult*>* searchResults= [[NSMutableArray<WRLDSearchResult*> alloc] init];

    if([poiSearchResponse succeeded])
    {
        for(WRLDPoiSearchResult *poiSearchResult in [poiSearchResponse results])
        {
            // Add to result set
            [searchResults addObject: [self createSearchResult: [poiSearchResult title] latLng: [poiSearchResult latLng] subTitle:[poiSearchResult subtitle] tags:[poiSearchResult tags]]];
        }
    }
    
    [m_currentQuery addResults: self :searchResults];

}

- (WRLDSearchResult*) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng subTitle: (NSString*)subTitle tags: (NSString*)tags
{
    WRLDSearchResult* searchResult = [[WRLDSearchResult alloc] init];
    [searchResult setTitle: title];
    [searchResult setLatLng: latLng];
    [searchResult setSubTitle: subTitle];
    [searchResult setTags: tags];
    return searchResult;
}

- (void) search: (WRLDSearchQuery*) query
{
    m_currentQuery = query;
    WRLDTextSearchOptions* textSearchOptions = [[WRLDTextSearchOptions alloc] init];
    [textSearchOptions setQuery: query.queryString];
    [textSearchOptions setCenter:  [m_mapView centerCoordinate]];
    m_poiSearchId = [[m_poiService searchText: textSearchOptions] poiSearchId];
}

- (void) searchSuggestions: (WRLDSearchQuery*) query
{
    m_currentQuery = query;
    WRLDAutocompleteOptions* autocompleteOptions = [[WRLDAutocompleteOptions alloc] init];
    [autocompleteOptions setQuery: query.queryString];
    [autocompleteOptions setCenter:  [m_mapView centerCoordinate]];
    m_poiSearchId = [[m_poiService searchAutocomplete: autocompleteOptions] poiSearchId];
}

@synthesize title;

@synthesize cellIdentifier;

@synthesize cellExpectedHeight;

@end

