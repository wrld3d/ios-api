#include "WRLDRoutingServiceHelpers.h"

#import "WRLDRoute.h"
#import "WRLDRouteSection.h"
#import "WRLDRouteDirections.h"
#import "WRLDRouteStep.h"
#import "WRLDRouteTransportationMode.h"

#import <CoreLocation/CoreLocation.h>

namespace Eegeo
{
    namespace Routes
    {
        namespace Webservice
        {
            namespace Helpers
            {
                WRLDRoutingQueryResponse* CreateWRLDRoutingQueryResponse(const Eegeo::Routes::Webservice::RoutingQueryResponse& result)
                {
                    WRLDRoutingQueryResponse* routingQueryResponse = [[WRLDRoutingQueryResponse alloc] init];
                    [routingQueryResponse setSucceeded:result.Succeeded];
                    routingQueryResponse.results = [[NSMutableArray alloc] initWithCapacity:(result.Results.size())];
                    for(auto& route : result.Results)
                    {
                        WRLDRoute* wrldRoute = [[WRLDRoute alloc] init];
                        wrldRoute.sections = [[NSMutableArray alloc] initWithCapacity:(route.Sections.size())];
                        for(auto& section : route.Sections)
                        {
                            WRLDRouteSection* routeSection = [[WRLDRouteSection alloc] init];
                            routeSection.steps = [[NSMutableArray alloc] initWithCapacity:(section.Steps.size())];
                            for(auto& step : section.Steps)
                            {
                                int pathCount = static_cast<int>(step.Path.size());
                                CLLocationCoordinate2D* path = new CLLocationCoordinate2D[pathCount];

                                for (int i=0; i<pathCount; i++)
                                {
                                    path[i] = CLLocationCoordinate2DMake(step.Path[i].GetLatitudeInDegrees(), step.Path[i].GetLongitudeInDegrees());
                                }

                                const Eegeo::Routes::Webservice::RouteDirections& directions = step.Directions;
                                WRLDRouteDirections* routeDirections = [[WRLDRouteDirections alloc] init];
                                [routeDirections setType: [NSString stringWithCString: directions.Type.c_str() encoding:NSUTF8StringEncoding]];
                                [routeDirections setModifier: [NSString stringWithCString: directions.Modifier.c_str() encoding:NSUTF8StringEncoding]];
                                [routeDirections setLatLng: CLLocationCoordinate2DMake(directions.Location.GetLatitudeInDegrees(), directions.Location.GetLongitudeInDegrees())];
                                [routeDirections setHeadingBefore:directions.BearingBefore];
                                [routeDirections setHeadingAfter:directions.BearingAfter];

                                NSInteger mode = (NSInteger) static_cast<int>(step.Mode);

                                WRLDRouteStep* routeStep = [[WRLDRouteStep alloc] init];
                                [routeStep setPath:path];
                                [routeStep setPathCount:pathCount];
                                [routeStep setDirections:routeDirections];
                                [routeStep setMode:(WRLDRouteTransportationMode)mode];
                                [routeStep setIsIndoors:step.IsIndoors];
                                [routeStep setIndoorId: [NSString stringWithCString: step.IndoorId.c_str() encoding:NSUTF8StringEncoding]];
                                [routeStep setIndoorFloorId:step.IndoorFloorId];
                                [routeStep setDuration:step.Duration];
                                [routeStep setDistance:step.Distance];
                                [routeSection.steps addObject:routeStep];
                            }

                            [routeSection setDuration:section.Duration];
                            [routeSection setDistance:section.Distance];
                            [wrldRoute.sections addObject:routeSection];
                        }

                        [wrldRoute setDuration:route.Duration];
                        [wrldRoute setDistance:route.Distance];
                        [routingQueryResponse.results addObject:wrldRoute];
                    }

                    return routingQueryResponse;
                }
            }
        }
    }
}
