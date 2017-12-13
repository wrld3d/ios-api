
#include "WRLDMapsceneStartLocation.h"

@interface WRLDMapsceneStartLocation ()

@end

@implementation WRLDMapsceneStartLocation
{

}

-(instancetype)initMapsceneStartLocation:(CLLocationCoordinate2D)coordinate distance:(CLLocationDistance)distance interiorFloorIndex:(int)interiorFloorIndex interiorId:(NSString*)interiorId heading:(double)heading tryStartAtGpsLocation:(bool)tryStartAtGpsLocation
{
    self = [super init];
    
    if(self)
    {
        _coordinate = coordinate;
        _distance = distance;
        _interiorFloorIndex = interiorFloorIndex;
        _interiorId = interiorId;
        _heading = heading;
        _tryStartAtGpsLocation = tryStartAtGpsLocation;
    }
    
    return self;
}


@end

