// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#pragma once
@import Wrld;
#import "SuggestionProvider.h"

@interface POIServiceSuggestionProvider : NSObject <SuggestionProvider, WRLDPoiSearchCompletedDelegate>

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService:(WRLDPoiService*)poiService;

@end


