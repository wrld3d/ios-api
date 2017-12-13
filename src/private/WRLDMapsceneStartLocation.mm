
#include "WRLDMapsceneStartLocation.h"

@interface WRLDMapsceneStartLocation ()

@end

@implementation WRLDMapsceneStartLocation
{
    CLLocationCoordinate2D m_coordinate;
    CLLocationDistance m_distance;
    int m_interiorFloorIndex;
    NSString* m_interiorId;
    double m_heading;
    bool m_tryStartAtGpsLocation;
}

-(CLLocationCoordinate2D)getCoordinate
{
    return m_coordinate;
}
-(CLLocationDistance)getDistance
{
    return m_distance;
}
-(int)getInteriorFloorIndex
{
    return m_interiorFloorIndex;
}
-(NSString*)getInteriorId
{
    return m_interiorId;
}
-(double)getHeading
{
    return m_heading;
}
-(bool)getTryStartAtGpsLocation
{
    return m_tryStartAtGpsLocation;
}

-(void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    m_coordinate = coordinate;
}
-(void)setDistance:(CLLocationDistance)distance
{
    m_distance = distance;
}
-(void)setInteriorFloorIndex:(int)interiorFloorIndex
{
    m_interiorFloorIndex = interiorFloorIndex;
}
-(void)setInteriorId:(NSString*)interiorId
{
    m_interiorId = interiorId;
}
-(void)setHeading:(double)heading
{
    m_heading = heading;
}
-(void)setTryStartAtGpsLocation:(bool)tryStartAtGpsLocation
{
    m_tryStartAtGpsLocation = tryStartAtGpsLocation;
}

@end

