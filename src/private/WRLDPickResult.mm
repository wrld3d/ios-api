#import "WRLDPickResult.h"
#import "WRLDPickResult+Private.h"

@interface WRLDPickResult ()

@end

@implementation WRLDPickResult
{
}

- (instancetype) initWithFeatureFound:(Boolean)found
                       mapFeatureType:(WRLDMapFeatureType)mapFeatureType
                    intersectionPoint:(WRLDCoordinateWithAltitude)intersectionPoint
            intersectionSurfaceNormal:(WRLDVector3)intersectionSurfaceNormal
{
    if (self = [super init])
    {
        _found = found;
        _mapFeatureType = mapFeatureType;
        _intersectionPoint = intersectionPoint;
        _intersectionSurfaceNormal = intersectionSurfaceNormal;
    }

    return self;
}

@end
