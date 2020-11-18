#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "WRLDRoutingPolylineCreateParams.h"
#import "WRLDRouteStep.h"
#include <vector>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRouteViewHelper : NSObject

+ (bool) areApproximatelyEqual:(const CLLocationCoordinate2D &)firstLocation
                secondLocation:(const CLLocationCoordinate2D &)secondLocation;

+ (void) removeCoincidentPoints:(const std::vector<CLLocationCoordinate2D> &)coordinates
                         output:(std::vector<CLLocationCoordinate2D> &)output;

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep *)routeStep
                                                                     andColor:(UIColor* )color;

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep *)routeStep
                                                                 forwardColor:(UIColor*)forwardColor
                                                                backwardColor:(UIColor*)backwardColor
                                                                   splitIndex:(int)splitIndex
                                                           closestPointOnPath:(CLLocationCoordinate2D)closestPointOnRoute;

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForFloorTransition:(WRLDRouteStep *)routeStep
                                                                   floorBefore:(int)floorBefore
                                                                    floorAfter:(int)floorAfter
                                                                       ndColor:(UIColor *)color;

+ (void) removeCoincidentPointsWithElevations:(std::vector<CLLocationCoordinate2D>&)coordinates
                               pointElevation:(std::vector<CGFloat>&)perPointElevations
                                     ndOutput:(std::vector<CLLocationCoordinate2D>&)output;

@end

NS_ASSUME_NONNULL_END
