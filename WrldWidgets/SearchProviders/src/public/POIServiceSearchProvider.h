#pragma once
@import Wrld;

#import "WRLDSearchProvider.h"

@interface POIServiceSearchProvider : WRLDSearchProviderBase <WRLDSearchProvider, WRLDPoiSearchCompletedDelegate>

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService;

@end


