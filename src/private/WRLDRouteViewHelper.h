#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRouteViewHelper : NSObject

+ (bool) areApproximatelyEqual:(CLLocation*)firstLocation secondLocation:(CLLocation*)secondLocation;
+ (NSMutableArray*) removeCoincidentPoints:(NSMutableArray*) coordinates;

@end

NS_ASSUME_NONNULL_END
