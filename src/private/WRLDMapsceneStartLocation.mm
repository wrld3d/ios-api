
#include "WRLDMapsceneStartLocation.h"

@interface WRLDMapsceneStartLocation ()

@end

@implementation WRLDMapsceneStartLocation{
    CLLocationCoordinate2D m_coordinate;
    CLLocationDistance m_altitude;
    
    int m_interiorFloorIndex;
    double m_heading;
    bool m_tryStartAtGpsLocation;
}

-(instancetype) initWRLDMapsceneStartLocationMake:(CLLocationCoordinate2D)coordinate :(CLLocationDistance)altitude :(int)interiorFloorIndex :(double)heading :(bool)tryStartAtGpsLocation
{
    self = [super init];
    
    if(self){
        m_coordinate = coordinate;
        m_altitude = altitude;
        m_heading = heading;
        m_interiorFloorIndex = interiorFloorIndex;
        m_tryStartAtGpsLocation = tryStartAtGpsLocation;
    }
    
    return self;
}

-(CLLocationCoordinate2D)getCoordinate{
    return m_coordinate;
}
-(CLLocationDistance)getAltitude{
    return m_altitude;
}
-(int)getInteriorFloorIndex{
    return m_interiorFloorIndex;
}
-(double)getHeading{
    return m_heading;
}
-(bool)getTryStartAtGpsLocation{
    return m_tryStartAtGpsLocation;
}

@end

