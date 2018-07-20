#pragma once

#include "RoutingQueryResponse.h"

#import "WRLDRoute.h"
#import "WRLDRouteSection.h"
#import "WRLDRouteDirections.h"
#import "WRLDRouteStep.h"
#import "WRLDRoutingQueryResponse.h"

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRoutingServiceHelpers : NSObject

+ (WRLDRoutingQueryResponse*)createWRLDRoutingQueryResponse:(const Eegeo::Routes::Webservice::RoutingQueryResponse&)withResponse;

+ (WRLDRoute*)createWRLDRoute:(const Eegeo::Routes::Webservice::RouteData&)withRoute;

+ (WRLDRouteSection*)createWRLDRouteSection:(const Eegeo::Routes::Webservice::RouteSection&)withSection;

+ (WRLDRouteStep*)createWRLDRouteStep:(const Eegeo::Routes::Webservice::RouteStep&)withStep;

+ (WRLDRouteDirections*)createWRLDRouteDirections:(const Eegeo::Routes::Webservice::RouteDirections&)withDirections;

+ (CLLocationCoordinate2D*)createWRLDRouteStepPath:(const std::vector<Eegeo::Space::LatLong>&) withPath;

@end

NS_ASSUME_NONNULL_END
