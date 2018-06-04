#pragma once

#import "WRLDRoutingQuery.h"
#import "WRLDRoutingQueryOptions.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 A service which allows you to find routes between locations. Created by the createRoutingService
 method of the WRLDMapView object.

 This is an Objective-c interface to the [WRLD Routing REST API](https://github.com/wrld3d/wrld-routing-api).
 */

@interface WRLDRoutingService : NSObject

/*!
 Asynchronously query the routing service.

 The results of the query will be passed
 as a WRLDRoutingQueryResponse to the routingQueryDidComplete method in WRLDMapViewDelegate.

 @param options The parameters of the routing query.
 @returns A handle to the ongoing query, which can be used to cancel it.
 */
- (WRLDRoutingQuery*)findRoutes:(WRLDRoutingQueryOptions*)options;

@end

NS_ASSUME_NONNULL_END
