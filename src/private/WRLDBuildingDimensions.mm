#import "WRLDBuildingDimensions.h"
#import "WRLDBuildingDimensions+Private.h"

@interface WRLDBuildingDimensions ()

@end

@implementation WRLDBuildingDimensions
{
    CLLocationDistance m_baseAltitude;
    CLLocationDistance m_topAltitude;
    CLLocationCoordinate2D m_centroid;
}

- (instancetype) initWithBaseAltitude:(CLLocationDistance)baseAltitude
                          topAltitude:(CLLocationDistance)topAltitude
                               centroid:(CLLocationCoordinate2D)centroid
{
    if (self = [super init])
    {
        m_baseAltitude = baseAltitude;
        m_topAltitude = topAltitude;
        m_centroid = centroid;
    }

    return self;
}

- (CLLocationDistance) baseAltitude
{
    return m_baseAltitude;
}

- (CLLocationDistance) topAltitude
{
    return m_topAltitude;
}

- (CLLocationCoordinate2D) centroid
{
    return m_centroid;
}

@end
