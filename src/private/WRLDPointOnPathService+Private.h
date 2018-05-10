#pragma once

#include "EegeoPointOnPathApi.h"


NS_ASSUME_NONNULL_BEGIN

@class WRLDPointOnPathService;

@interface WRLDPointOnPathService (Private)

- (instancetype)initWithApi:(Eegeo::Api::EegeoPointOnPathApi&)pointOnPathApi;

- (std::vector<Eegeo::Space::LatLong>) makeLatLongPath:(CLLocationCoordinate2D*)path
                                       count:(NSInteger)count;

- (Eegeo::Routes::Webservice::RouteData*) makeRouteDataFromWRLDRoute:(WRLDRoute*)route;

- (WRLDPointOnRouteInfo*) makeWRLDPointOnRouteInfoFromPlatform:(Eegeo::Routes::PointOnRoute)pointOnRouteInfo withRoute:(WRLDRoute*)route;

@end

NS_ASSUME_NONNULL_END
