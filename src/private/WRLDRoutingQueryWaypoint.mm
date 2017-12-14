#import "WRLDRoutingQueryWaypoint.h"
#import "WRLDRoutingQueryWaypoint+Private.h"

@interface WRLDRoutingQueryWaypoint ()

@end

@implementation WRLDRoutingQueryWaypoint
{
    CLLocationCoordinate2D m_latLng;
    BOOL m_isIndoors;
    int m_indoorFloorId;
}

- (instancetype)initWithLatLng:(CLLocationCoordinate2D)latLng
                     isIndoors:(BOOL)isIndoors
                 indoorFloorId:(int)indoorFloorId
{
    if (self = [super init])
    {
        m_latLng = latLng;
        m_isIndoors = isIndoors;
        m_indoorFloorId = indoorFloorId;
    }

    return self;
}

- (CLLocationCoordinate2D) latLng
{
    return m_latLng;
}

- (BOOL) isIndoors
{
    return m_isIndoors;
}

- (int) indoorFloorId
{
    return m_indoorFloorId;
}

@end
