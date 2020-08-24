#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <vector>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRouteViewHelper : NSObject

+ (bool) areApproximatelyEqual:(CLLocation*)firstLocation secondLocation:(CLLocation*)secondLocation;
+ (NSMutableArray*) removeCoincidentPoints:(NSMutableArray*) coordinates;
+ (std::vector<CLLocationCoordinate2D>) removeCoincidentPointsFromVector:(std::vector<CLLocationCoordinate2D>) coordinates;
@end

NS_ASSUME_NONNULL_END
