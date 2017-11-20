#pragma once
@import Wrld;

#import "WRLDSearchProvider.h"

@interface POIServiceSearchProvider : WRLDSearchProviderBase <WRLDSearchProvider, WRLDPoiSearchCompletedDelegate>

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService;

- (WRLDSearchResult*) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng subTitle: (NSString*)subTitle;


@end


