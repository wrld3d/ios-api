#import "WRLDRoutingService.h"
#import "WRLDRoutingService+Private.h"
#import "WRLDRoutingQuery.h"
#import "WRLDRoutingQuery+Private.h"

#include "WRLDRoutingQueryOptions.h"
#include "WRLDRoutingQueryWaypoint.h"

#include "RoutingQueryOptions.h"

#include <vector>

@implementation WRLDRoutingService
{
    Eegeo::Api::EegeoRoutingApi* m_routingApi;
}

- (instancetype)initWithApi:(Eegeo::Api::EegeoRoutingApi&)routingApi;
{
    if (self = [super init])
    {
        m_routingApi = &routingApi;
    }

    return self;
}

- (WRLDRoutingQuery*)findRoutes:(WRLDRoutingQueryOptions*)options
{
    std::vector<Eegeo::Routes::Webservice::RoutingQueryWaypoint> routingQueryWaypoints;

    NSMutableArray* waypoints = [options getWaypoints];
    routingQueryWaypoints.reserve([waypoints count]);

    for(WRLDRoutingQueryWaypoint* waypoint : waypoints)
    {
        CLLocationCoordinate2D waypointLatLng = waypoint.latLng;
        Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(waypointLatLng.latitude, waypointLatLng.longitude);
        Eegeo::Routes::Webservice::RoutingQueryWaypoint routingQueryWaypoint =
        {
            {latLng.GetLatitude(), latLng.GetLongitude()},
            static_cast<bool>(waypoint.isIndoors),
            static_cast<int>(waypoint.indoorFloorId)
        };

        routingQueryWaypoints.emplace_back(routingQueryWaypoint);
    }

    Eegeo::Routes::Webservice::RoutingQueryOptions routingQueryOptions =
    {
        routingQueryWaypoints
    };

    return [[WRLDRoutingQuery alloc] initWithIdAndApi: m_routingApi->BeginRoutingQuery(routingQueryOptions) routingApi:*m_routingApi];
}

@end
