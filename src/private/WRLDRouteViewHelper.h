#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "WRLDRoutingPolylineCreateParams.h"
#import "WRLDRouteStep.h"
#include <vector>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRouteViewHelper : NSObject

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep *)routeStep
                                                                        color:(UIColor *)color;

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep *)routeStep
                                                                 forwardColor:(UIColor*)forwardColor
                                                                backwardColor:(UIColor*)backwardColor
                                                                   splitIndex:(int)splitIndex
                                                           closestPointOnPath:(CLLocationCoordinate2D)closestPointOnRoute;

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForFloorTransition:(WRLDRouteStep *)routeStep
                                                                   floorBefore:(int)floorBefore
                                                                    floorAfter:(int)floorAfter
                                                                         color:(UIColor *)color;

+ (void) removeCoincidentPoints:(std::vector<CLLocationCoordinate2D> &)coordinates;

+ (void) removeCoincidentPointsWithElevations:(std::vector<CLLocationCoordinate2D>&)coordinates
                               pointElevation:(std::vector<CGFloat>&)perPointElevations;

@end

NS_ASSUME_NONNULL_END
