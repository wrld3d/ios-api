#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "WRLDRoutingPolylineCreateParams.h"
#import "WRLDRouteStep.h"
#include <vector>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDRouteViewHelper : NSObject

+ (std::vector<WRLDRoutingPolylineCreateParams>)CreateLinesForRouteDirection:(WRLDRouteStep*)routeStep
                                                              isForwardColor:(bool)isForwardColor;

+ (std::vector<WRLDRoutingPolylineCreateParams>)CreateLinesForRouteDirection:(WRLDRouteStep*)routeStep
                                                                  splitIndex:(int)splitIndex
                                                          closestPointOnPath:(CLLocationCoordinate2D)closestPointOnRoute;

+ (std::vector<WRLDRoutingPolylineCreateParams>)CreateLinesForFloorTransition:(WRLDRouteStep*)routeStep
                                                                  floorBefore:(int)floorBefore
                                                                   floorAfter:(int)floorAfter
                                                               isForwardColor:(bool)isForwardColor;

+ (void)removeCoincidentPoints:(std::vector<CLLocationCoordinate2D>&)coordinates;

+ (void)removeCoincidentPointsWithElevations:(std::vector<CLLocationCoordinate2D>&)coordinates
                           perPointElevation:(std::vector<CGFloat>&)perPointElevations;

@end

NS_ASSUME_NONNULL_END
