#import "WRLDPickResult.h"

#include <vector>

NS_ASSUME_NONNULL_BEGIN

@class WRLDPickResult;

@interface WRLDPickResult (Private)

- (instancetype) initWithFeatureFound:(Boolean)found
                       mapFeatureType:(WRLDMapFeatureType)mapFeatureType
                    intersectionPoint:(WRLDCoordinateWithAltitude)intersectionPoint
            intersectionSurfaceNormal:(WRLDVector3)intersectionSurfaceNormal;

@end

NS_ASSUME_NONNULL_END
