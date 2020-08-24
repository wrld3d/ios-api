#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <vector>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRouteViewHelper : NSObject

+ (bool) areApproximatelyEqualNew:(CLLocationCoordinate2D)firstLocation secondLocation:(CLLocationCoordinate2D)secondLocation;
+ (std::vector<CLLocationCoordinate2D>) removeCoincidentPoints:(std::vector<CLLocationCoordinate2D>) coordinates;
@end

NS_ASSUME_NONNULL_END
