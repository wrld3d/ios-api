#import "WRLDBuildingContour.h"
#import "WRLDBuildingContour+Private.h"

@interface WRLDBuildingContour ()

@end

@implementation WRLDBuildingContour
{
    CLLocationDistance m_bottomAltitude;
    CLLocationDistance m_topAltitude;
    CLLocationCoordinate2D* m_points;
    int m_pointCount;
}

- (instancetype) initWithBottomAltitude:(CLLocationDistance)bottomAltitude
                           topAltitude:(CLLocationDistance)topAltitude
                                points:(CLLocationCoordinate2D*)points
                             pointCount:(int)pointCount
{
    if (self = [super init])
    {
        m_bottomAltitude = bottomAltitude;
        m_topAltitude = topAltitude;
        m_points = points;
        m_pointCount = pointCount;
    }

    return self;
}

- (CLLocationDistance) bottomAltitude
{
    return m_bottomAltitude;
}

- (CLLocationDistance) topAltitude
{
    return m_topAltitude;
}

- (CLLocationCoordinate2D*) points
{
    return m_points;
}

- (int) pointCount
{
    return m_pointCount;
}

@end
