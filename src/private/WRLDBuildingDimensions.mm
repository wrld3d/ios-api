#import "WRLDBuildingDimensions.h"
#import "WRLDBuildingDimensions+Private.h"

@interface WRLDBuildingDimensions ()

@end

@implementation WRLDBuildingDimensions
{

}

- (instancetype) initWithBaseAltitude:(CLLocationDistance)baseAltitude
                          topAltitude:(CLLocationDistance)topAltitude
                               centroid:(CLLocationCoordinate2D)centroid
{
    if (self = [super init])
    {
        _baseAltitude = baseAltitude;
        _topAltitude = topAltitude;
        _centroid = centroid;
    }

    return self;
}

@end
