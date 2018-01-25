#import "WRLDBuildingContour.h"
#import "WRLDBuildingContour+Private.h"

@interface WRLDBuildingContour ()

@end

@implementation WRLDBuildingContour
{
    
}

- (instancetype) initWithBottomAltitude:(CLLocationDistance)bottomAltitude
                           topAltitude:(CLLocationDistance)topAltitude
                                points:(CLLocationCoordinate2D*)points
                             pointCount:(int)pointCount
{
    if (self = [super init])
    {
        _bottomAltitude = bottomAltitude;
        _topAltitude = topAltitude;
        _points = points;
        _pointCount = pointCount;
    }

    return self;
}

@end
