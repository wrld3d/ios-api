#pragma once
@import Wrld;
@import WrldSearchWidget;

@interface WRLDPoiServiceSearchProvider : NSObject <WRLDSearchProvider, WRLDSuggestionProvider, WRLDMapViewDelegate>

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService;

@end
