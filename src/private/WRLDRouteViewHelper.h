#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <vector>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRouteViewHelper : NSObject

+ (bool) areApproximatelyEqualNew:(const CLLocationCoordinate2D &)firstLocation secondLocation:(const CLLocationCoordinate2D &)secondLocation;
+ (void) removeCoincidentPoints:(const std::vector<CLLocationCoordinate2D> &)coordinates output:(std::vector<CLLocationCoordinate2D> &)output;
@end

NS_ASSUME_NONNULL_END
