
#import "WRLDPoiService.h"
#import "WRLDPoiService+Private.h"
#import "WRLDPoiSearch.h"
#import "WRLDPoiSearch+Private.h"

#include "PoiSearchOptions.h"

@implementation WRLDPoiService
{
    Eegeo::Api::EegeoPoiApi* m_poiApi;
}

- (instancetype)initWithApi:(Eegeo::Api::EegeoPoiApi&)poiApi
{
    if (self = [super init])
    {
        m_poiApi = &poiApi;
    }
    
    return self;
}

- (WRLDPoiSearch*)searchText:(WRLDTextSearchOptions*)options
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees([options getCenter].latitude, [options getCenter].longitude);
    
    Eegeo::PoiSearch::TextSearchOptions textOptions =
    {
        [[options getQuery] UTF8String],
        {latLng.GetLatitude(), latLng.GetLongitude()},
        static_cast<bool>([options usesRadius]),            [options getRadius],
        static_cast<bool>([options usesNumber]),            static_cast<int>([options getNumber]),
        static_cast<bool>([options usesMinScore]),          [options getMinScore],
        static_cast<bool>([options usesIndoorMapId]),       [[options getIndoorMapId] UTF8String],
        static_cast<bool>([options usesIndoorMapFloorId]),  static_cast<int>([options getIndoorMapFloorId]),
        static_cast<bool>([options usesFloorDropoff]),      static_cast<int>([options getFloorDropoff])
    };
    
    return [[WRLDPoiSearch alloc] initWithIdAndApi: m_poiApi->BeginTextSearch(textOptions) poiApi:*m_poiApi];
}

- (WRLDPoiSearch*)searchTag:(WRLDTagSearchOptions*)options
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees([options getCenter].latitude, [options getCenter].longitude);
    
    Eegeo::PoiSearch::TagSearchOptions tagOptions =
    {
        [[options getQuery] UTF8String],
        {latLng.GetLatitude(), latLng.GetLongitude()},
        static_cast<bool>([options usesRadius]),            [options getRadius],
        static_cast<bool>([options usesNumber]),            static_cast<int>([options getNumber])
    };
    
    return [[WRLDPoiSearch alloc] initWithIdAndApi: m_poiApi->BeginTagSearch(tagOptions) poiApi:*m_poiApi];
}

- (WRLDPoiSearch*)searchAutocomplete:(WRLDAutocompleteOptions*)options
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees([options getCenter].latitude, [options getCenter].longitude);
    
    Eegeo::PoiSearch::AutocompleteOptions autoCompleteOptions =
    {
        [[options getQuery] UTF8String],
        {latLng.GetLatitude(), latLng.GetLongitude()},
        static_cast<bool>([options usesNumber]),            static_cast<int>([options getNumber])
    };
    
    return [[WRLDPoiSearch alloc] initWithIdAndApi: m_poiApi->BeginAutocompleteSearch(autoCompleteOptions) poiApi:*m_poiApi];
}

@end



