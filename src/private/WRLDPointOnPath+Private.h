#pragma once

#include "EegeoPathApi.h"


NS_ASSUME_NONNULL_BEGIN

@class WRLDPointOnPath;

@interface WRLDPointOnPath (Private)

- (instancetype)initWithApi:(Eegeo::Api::EegeoPathApi&)pathApi;

- (std::vector<Eegeo::Space::LatLong>) makeLatLongPath:(CLLocationCoordinate2D*)path
                                       count:(NSInteger)count;

- (Eegeo::Routes::Webservice::RouteData*) makeRouteDataFromWRLDRoute:(WRLDRoute*)route;

- (WRLDPointOnRouteResult*) makeWRLDPointOnRouteFromPlatform:(Eegeo::Routes::PointOnRoute)pointOnRouteInfo withRoute:(WRLDRoute*)route;

@end

NS_ASSUME_NONNULL_END
