#import "WRLDPointOnPath.h"
#import "WRLDPointOnPath+Private.h"
#import "WRLDPointOnRouteResult+Private.h"
#import "WRLDPointOnPathResult+Private.h"

#import <CoreLocation/CoreLocation.h>

#include <vector>


@implementation WRLDPointOnPath
{
    Eegeo::Api::EegeoPathApi* m_pathApi;
}

- (instancetype)initWithApi:(Eegeo::Api::EegeoPathApi&)pathApi
{
    if (self = [super init])
    {
        m_pathApi = &pathApi;
    }

    return self;
}

- (std::vector<Eegeo::Space::LatLong>) makeLatLongPath:(CLLocationCoordinate2D*)path
                                       count:(NSInteger)count
{
    std::vector<Eegeo::Space::LatLong> latLngPath;
    
    for(NSInteger i = 0; i < count; ++i)
    {
        CLLocationCoordinate2D coord = path[i];
        latLngPath.push_back(Eegeo::Space::LatLong::FromDegrees(coord.latitude, coord.longitude));
    }

    return latLngPath;
}

- (Eegeo::Routes::Webservice::RouteData*) makeRouteDataFromWRLDRoute:(WRLDRoute*)route
{
    Eegeo::Routes::Webservice::RouteData* routeData = new Eegeo::Routes::Webservice::RouteData();

    routeData->Distance = route.distance;
    routeData->Duration = route.duration;
    
    routeData->Sections.reserve(route.sections.count);
    for(WRLDRouteSection* routeSection in route.sections)
    {
        Eegeo::Routes::Webservice::RouteSection newSection;
        
        newSection.Distance = routeSection.distance;
        newSection.Duration = routeSection.duration;
        
        newSection.Steps.reserve(routeSection.steps.count);
        for(WRLDRouteStep* routeStep in routeSection.steps)
        {
            std::vector<Eegeo::Space::LatLong> path = [self makeLatLongPath:routeStep.path count:routeStep.pathCount];
            
            Eegeo::Routes::Webservice::TransportationMode transportationMode = (Eegeo::Routes::Webservice::TransportationMode)((int)routeStep.mode);
            
            
            Eegeo::Routes::Webservice::RouteDirections directions = { Eegeo::Space::LatLong::FromDegrees(routeStep.directions.latLng.latitude,
                                                                      routeStep.directions.latLng.longitude),
                                                                      std::string([routeStep.directions.type UTF8String]),
                                                                      std::string([routeStep.directions.modifier UTF8String]),
                                                                      routeStep.directions.headingBefore,
                                                                      routeStep.directions.headingAfter };
            
            
            Eegeo::Routes::Webservice::RouteStep newStep = { path,
                                                             transportationMode,
                                                             std::string([routeStep.indoorId UTF8String]),
                                                             "",
                                                             directions,
                                                             routeStep.duration,
                                                             routeStep.distance,
                                                             routeStep.indoorFloorId,
                                                             (bool)routeStep.isIndoors,
                                                             (bool)routeStep.isMultiFloor };
            newSection.Steps.push_back(newStep);
        }
        
        
        routeData->Sections.push_back(newSection);
    }
    
    
    return routeData;
}

- (WRLDPointOnRouteResult*) makeWRLDPointOnRouteFromPlatform:(Eegeo::Routes::PointOnRoute)pointOnRouteInfo withRoute:(WRLDRoute*)route
{
    CLLocationCoordinate2D resultPoint = CLLocationCoordinate2DMake(pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetResultPoint().GetLatitudeInDegrees(),
                                                                    pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetResultPoint().GetLongitudeInDegrees());
    
    CLLocationCoordinate2D inputPoint = CLLocationCoordinate2DMake(pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetInputPoint().GetLatitudeInDegrees(),
                                                                pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetInputPoint().GetLongitudeInDegrees());
    
    double distanceFromInputPoint = pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetDistanceFromInputPoint();
    
    double fractionAlongRouteStep = pointOnRouteInfo.GetFractionAlongRouteStep();
    
    double fractionAlongRouteSection = pointOnRouteInfo.GetFractionAlongRouteSection();
    
    double fractionAlongRoute = pointOnRouteInfo.GetFractionAlongRoute();
    
    WRLDRouteSection *routeSection = [route.sections objectAtIndex:pointOnRouteInfo.GetRouteSectionIndex()];
    
    WRLDRouteStep *routeStep = [routeSection.steps objectAtIndex:pointOnRouteInfo.GetRouteStepIndex()];
    
    WRLDPointOnRouteResult* newPointOnRouteInfo = [[WRLDPointOnRouteResult alloc] initWithResultPoint:resultPoint inputPoint:inputPoint distanceFromInputPoint:distanceFromInputPoint fractionAlongRoute:fractionAlongRoute fractionAlongRouteSection:fractionAlongRouteSection fractionAlongRouteStep:fractionAlongRouteStep routeStep:routeStep routeSection:routeSection];
    
    return newPointOnRouteInfo;
}

- (WRLDPointOnPathResult*) getPointOnPath:(CLLocationCoordinate2D* )path
                                    count:(NSInteger)count
                                    point:(CLLocationCoordinate2D)point
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    
    Eegeo::Geometry::Paths::PointOnPath pointOnPath = m_pathApi->GetPointOnPath(latLng, [self makeLatLongPath:path count:count]);
    
    CLLocationCoordinate2D resultPoint = CLLocationCoordinate2DMake(pointOnPath.GetResultPoint().GetLatitudeInDegrees(), pointOnPath.GetResultPoint().GetLongitudeInDegrees());
    CLLocationCoordinate2D inputPoint = point;
    double fractionAlongPath = pointOnPath.GetFractionAlongPath();
    double distanceFromInputPoint = pointOnPath.GetDistanceFromInputPoint();
    int indexOfPathSegmentStartVertex = pointOnPath.GetIndexOfPathSegmentStartVertex();
    int indexOfPathSegmentEndVertex = pointOnPath.GetIndexOfPathSegmentEndVertex();
    
    WRLDPointOnPathResult* wrldPointOnPathResult = [[WRLDPointOnPathResult alloc] initWithResultPoint:resultPoint inputPoint:inputPoint
                                                                               distanceFromInputPoint:distanceFromInputPoint
                                                                                    fractionAlongPath:fractionAlongPath
                                                                        indexOfPathSegmentStartVertex:indexOfPathSegmentStartVertex
                                                                          indexOfPathSegmentEndVertex:indexOfPathSegmentEndVertex];
    
    return wrldPointOnPathResult;
}

- (WRLDPointOnRouteResult*) getPointOnRoute:(WRLDRoute*)route
                                point:(CLLocationCoordinate2D)point
                                options:(WRLDPointOnRouteOptions*)options
{
    const auto& latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    Eegeo::Routes::Webservice::RouteData* routeData = [self makeRouteDataFromWRLDRoute:route];
    
    Eegeo::Routes::PointOnRouteOptions pointOnRouteOptions;
    pointOnRouteOptions.IndoorMapId = std::string([options.getIndoorMapId UTF8String]);
    pointOnRouteOptions.IndoorMapFloorId = static_cast<int>(options.getIndoorMapFloorId);
    
    const auto& pointOnRoute = m_pathApi->GetPointOnRoute(latLng, *routeData, pointOnRouteOptions);

    if(!pointOnRoute.IsValidResult())
    {
        return nil;
    }

    WRLDPointOnRouteResult* pointOnRouteInfo = [self makeWRLDPointOnRouteFromPlatform:pointOnRoute withRoute:route];
    
    return pointOnRouteInfo;
}


@end
