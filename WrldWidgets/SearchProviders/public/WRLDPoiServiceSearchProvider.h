#pragma once
@import Wrld;

#import "WRLDSearchProvider.h"

@interface WRLDPoiServiceSearchProvider : NSObject <WRLDSearchProvider, WRLDMapViewDelegate>

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService;

@end
