#pragma once
@import Wrld;

#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProvider.h"

@interface WRLDPoiServiceSearchProvider : NSObject <WRLDSearchProvider, WRLDSuggestionProvider, WRLDMapViewDelegate>

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService;

@end
