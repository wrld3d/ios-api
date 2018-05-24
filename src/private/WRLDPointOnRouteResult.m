#import <Foundation/Foundation.h>

#import "WRLDPointOnRouteResult.h"
#import "WRLDPointOnRouteResult+Private.h"

@interface WRLDPointOnRouteResult ()

@end

@implementation WRLDPointOnRouteResult

- (instancetype) initWithResultPoint:(CLLocationCoordinate2D)resultPoint
                          inputPoint:(CLLocationCoordinate2D)inputPoint
              distanceFromInputPoint:(double)distanceFromInputPoint
                  fractionAlongRoute:(double)fractionAlongRoute
           fractionAlongRouteSection:(double)fractionAlongRouteSection
              fractionAlongRouteStep:(double)fractionAlongRouteStep
                           routeStep:(WRLDRouteStep*)routeStep
                        routeSection:(WRLDRouteSection*)routeSection
{
    if (self = [super init])
    {
        _resultPoint = resultPoint;
        _inputPoint = inputPoint;
        _distanceFromInputPoint = distanceFromInputPoint;
        _fractionAlongRoute = fractionAlongRoute;
        _fractionAlongRouteSection = fractionAlongRouteSection;
        _fractionAlongRouteStep = fractionAlongRouteStep;
        _routeStep = routeStep;
        _routeSection = routeSection;
    }
    
    return self;
}

@end
