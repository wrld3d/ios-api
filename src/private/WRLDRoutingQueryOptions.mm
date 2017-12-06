
#import "WRLDRoutingQueryOptions.h"
#import "WRLDRoutingQueryWaypoint.h"

@interface WRLDRoutingQueryOptions ()

@end

@implementation WRLDRoutingQueryOptions
{
    NSMutableArray* m_waypoints;
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        m_waypoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addWaypoint:(CLLocationCoordinate2D)latLng
{
    WRLDRoutingQueryWaypoint* routingQueryWaypoint = [[WRLDRoutingQueryWaypoint alloc] init];
    [routingQueryWaypoint setLatLng:latLng];
    [routingQueryWaypoint setIsIndoors:false];
    [routingQueryWaypoint setIndoorFloorId:0];

    [m_waypoints addObject:routingQueryWaypoint];
}

- (void)addIndoorWaypoint:(CLLocationCoordinate2D)latLng forIndoorFloor:(int)indoorFloorId
{
    WRLDRoutingQueryWaypoint* routingQueryWaypoint = [[WRLDRoutingQueryWaypoint alloc] init];
    [routingQueryWaypoint setLatLng:latLng];
    [routingQueryWaypoint setIsIndoors:true];
    [routingQueryWaypoint setIndoorFloorId:indoorFloorId];

    [m_waypoints addObject:routingQueryWaypoint];
}

- (NSMutableArray*)getWaypoints
{
    return m_waypoints;
}

@end

