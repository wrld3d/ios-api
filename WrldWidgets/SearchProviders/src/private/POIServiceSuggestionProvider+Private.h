#pragma once

#import <Foundation/Foundation.h>
#import "WRLDPoiService.h"
#import "WRLDMapView.h"

@class POIServiceSuggestionProvider;

@protocol POIServiceSuggestionProvider <SuggestionProvider>

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService: (WRLDPoiService*)poiService;

@end

