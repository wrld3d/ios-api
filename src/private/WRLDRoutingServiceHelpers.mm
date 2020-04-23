#include "WRLDRoutingServiceHelpers.h"

#import "WRLDRoutingQueryResponse+Private.h"
#import "WRLDRoute+Private.h"
#import "WRLDRouteSection+Private.h"
#import "WRLDRouteStep+Private.h"
#import "WRLDRouteDirections+Private.h"
#import "WRLDRouteTransportationMode.h"

@interface WRLDRoutingServiceHelpers ()

@end

@implementation WRLDRoutingServiceHelpers
{

}

+ (WRLDRoutingQueryResponse*)createWRLDRoutingQueryResponse:(const Eegeo::Routes::Webservice::RoutingQueryResponse&)withResponse
{

    NSMutableArray* results = [[NSMutableArray alloc] initWithCapacity:(withResponse.Results.size())];
    for(auto& route : withResponse.Results)
    {
        WRLDRoute* wrldRoute = [WRLDRoutingServiceHelpers createWRLDRoute:route];
        [results addObject:wrldRoute];
    }
    
    WRLDRoutingQueryResponse* routingQueryResponse = [[WRLDRoutingQueryResponse alloc] initWithStatusAndResults:withResponse.Succeeded
                                                                                                        results:results];
    return routingQueryResponse;
}

+ (WRLDRoute*)createWRLDRoute:(const Eegeo::Routes::Webservice::RouteData&)withRoute
{
    NSMutableArray* sections = [[NSMutableArray alloc] initWithCapacity:(withRoute.Sections.size())];
    for(auto& section : withRoute.Sections)
    {
        WRLDRouteSection* routeSection = [WRLDRoutingServiceHelpers createWRLDRouteSection:section];
        [sections addObject:routeSection];
    }
    
    WRLDRoute* wrldRoute = [[WRLDRoute alloc] initWithSections:sections
                                                      duration:withRoute.Duration
                                                      distance:withRoute.Distance];
    return wrldRoute;
}

+ (WRLDRouteSection*)createWRLDRouteSection:(const Eegeo::Routes::Webservice::RouteSection&)withSection
{
    NSMutableArray* steps = [[NSMutableArray alloc] initWithCapacity:(withSection.Steps.size())];
    for(auto& step : withSection.Steps)
    {
        WRLDRouteStep* routeStep = [WRLDRoutingServiceHelpers createWRLDRouteStep:step];
        [steps addObject:routeStep];
    }

    WRLDRouteSection* routeSection = [[WRLDRouteSection alloc] initWithSteps:steps
                                                                    duration:withSection.Duration
                                                                    distance:withSection.Distance];
    return routeSection;
}

+ (WRLDRouteStep*)createWRLDRouteStep:(const Eegeo::Routes::Webservice::RouteStep&)withStep
{
    CLLocationCoordinate2D* path = [WRLDRoutingServiceHelpers createWRLDRouteStepPath:withStep.Path];

    int pathCount = static_cast<int>(withStep.Path.size());

    WRLDRouteDirections* routeDirections = [WRLDRoutingServiceHelpers createWRLDRouteDirections:withStep.Directions];

    NSInteger mode = (NSInteger) static_cast<int>(withStep.Mode);

    WRLDRouteStep* routeStep = [[WRLDRouteStep alloc] initWithPath:path
                                                         pathCount:pathCount
                                                        directions:routeDirections
                                                              mode:(WRLDRouteTransportationMode)mode
                                                         isIndoors:withStep.IsIndoors
                                                          indoorId:[NSString stringWithCString: withStep.IndoorId.c_str() encoding:NSUTF8StringEncoding]
                                                      isMultiFloor:withStep.IsMultiFloor
                                                     indoorFloorId:withStep.IndoorFloorId
                                                          duration:withStep.Duration
                                                          distance:withStep.Distance
                                                          stepName:[NSString stringWithCString: withStep.Name.c_str() encoding:NSUTF8StringEncoding]];
    return routeStep;
}

+ (WRLDRouteDirections*)createWRLDRouteDirections:(const Eegeo::Routes::Webservice::RouteDirections&)withDirections
{
    WRLDRouteDirections* routeDirections = [[WRLDRouteDirections alloc] initWithType:[NSString stringWithCString: withDirections.Type.c_str() encoding:NSUTF8StringEncoding]
                                                                            modifier:[NSString stringWithCString: withDirections.Modifier.c_str() encoding:NSUTF8StringEncoding]
                                                                              latLng:CLLocationCoordinate2DMake(withDirections.Location.GetLatitudeInDegrees(), withDirections.Location.GetLongitudeInDegrees())
                                                                       headingBefore:withDirections.BearingBefore
                                                                        headingAfter:withDirections.BearingAfter];

    return routeDirections;
}

+ (CLLocationCoordinate2D*)createWRLDRouteStepPath:(const std::vector<Eegeo::Space::LatLong>&) withPath;
{
    int pathCount = static_cast<int>(withPath.size());
    CLLocationCoordinate2D* path = new CLLocationCoordinate2D[pathCount];

    for (int i=0; i<pathCount; i++)
    {
        const Eegeo::Space::LatLong& pathLatLong = withPath[i];
        path[i] = CLLocationCoordinate2DMake(pathLatLong.GetLatitudeInDegrees(), pathLatLong.GetLongitudeInDegrees());
    }

    return path;
}

+ (Eegeo::Routes::Webservice::TransportationMode) ToWRLDTransportationMode:(WRLDRouteTransportationMode)type
{
    Eegeo::Routes::Webservice::TransportationMode transportationMode;
    
    switch (type)
    {
        case WRLDRouteTransportationMode::WRLDWalking:
            transportationMode = Eegeo::Routes::Webservice::TransportationMode::Walking;
            break;
        case WRLDRouteTransportationMode::WRLDDriving:
            transportationMode = Eegeo::Routes::Webservice::TransportationMode::Driving;
            break;
            
        default:
            transportationMode = Eegeo::Routes::Webservice::TransportationMode::Walking;
            break;
    }
    
    return transportationMode;
}

@end
