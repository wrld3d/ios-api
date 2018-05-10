#import "WRLDPointOnPathService.h"
#import "WRLDPointOnPathService+Private.h"

#import <CoreLocation/CoreLocation.h>

#include <vector>


@implementation WRLDPointOnPathService
{
    Eegeo::Api::EegeoPointOnPathApi* m_pointOnPathApi;
}

- (instancetype)initWithApi:(Eegeo::Api::EegeoPointOnPathApi&)pointOnPathApi
{
    if (self = [super init])
    {
        m_pointOnPathApi = &pointOnPathApi;
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

- (WRLDPointOnRoute*) makeWRLDPointOnRouteFromPlatform:(Eegeo::Routes::PointOnRoute)pointOnRouteInfo withRoute:(WRLDRoute*)route
{
    WRLDPointOnRoute* newPointOnRouteInfo = [[WRLDPointOnRoute alloc] init];
    
    newPointOnRouteInfo.resultPoint = CLLocationCoordinate2DMake(pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetResultPoint().GetLatitudeInDegrees(),
                                                                    pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetResultPoint().GetLongitudeInDegrees());
    
    newPointOnRouteInfo.inputPoint = CLLocationCoordinate2DMake(pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetInputPoint().GetLatitudeInDegrees(),
                                                                pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetInputPoint().GetLongitudeInDegrees());
    
    newPointOnRouteInfo.distanceFromInputPoint = pointOnRouteInfo.GetPointOnPathForClosestRouteStep().GetDistanceFromInputPoint();
    
    newPointOnRouteInfo.fractionAlongRouteStep = pointOnRouteInfo.GetFractionAlongRouteStep();
    
    newPointOnRouteInfo.fractionAlongRouteSection = pointOnRouteInfo.GetFractionAlongRouteSection();
    
    newPointOnRouteInfo.fractionAlongRoute = pointOnRouteInfo.GetFractionAlongRoute();
    
    newPointOnRouteInfo.routeSection = [route.sections objectAtIndex:pointOnRouteInfo.GetRouteSectionIndex()];
    
    newPointOnRouteInfo.routeStep = [newPointOnRouteInfo.routeSection.steps objectAtIndex:pointOnRouteInfo.GetRouteStepIndex()];
    
    return newPointOnRouteInfo;
}

- (CLLocationCoordinate2D) getPointOnPath:(CLLocationCoordinate2D* )path
                           count:(NSInteger)count
                           point:(CLLocationCoordinate2D)point
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    
    Eegeo::Space::LatLong projectedPoint = m_pointOnPathApi->GetPointOnPath(latLng, [self makeLatLongPath:path count:count]).GetResultPoint();
    
    return CLLocationCoordinate2DMake(projectedPoint.GetLatitudeInDegrees(), projectedPoint.GetLongitudeInDegrees());
}

- (CGFloat) getPointFractionAlongPath:(CLLocationCoordinate2D *)path
                                count:(NSInteger)count
                                point:(CLLocationCoordinate2D)point
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    return (CGFloat)m_pointOnPathApi->GetPointOnPath(latLng, [self makeLatLongPath:path count:count]).GetFractionAlongPath();
}

- (WRLDPointOnRoute*) getPointOnRoute:(WRLDRoute*)route
                                point:(CLLocationCoordinate2D)point
                                withIndoorMapId:(NSString*)indoorMapId
                                indoorMapFloorId:(NSInteger)indoorMapFloorId
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    Eegeo::Routes::Webservice::RouteData* routeData = [self makeRouteDataFromWRLDRoute:route];
    
    Eegeo::Routes::PointOnRouteOptions pointOnRouteOptions;
    pointOnRouteOptions.IndoorMapId = std::string([indoorMapId UTF8String]);
    pointOnRouteOptions.IndoorMapFloorId = indoorMapFloorId;
    
    Eegeo::Routes::PointOnRoute pointOnRoute = m_pointOnPathApi->GetPointOnRoute(latLng, *routeData, pointOnRouteOptions);

    if(!pointOnRoute.IsValidResult())
    {
        return nil;
    }

    WRLDPointOnRoute* pointOnRouteInfo = [self makeWRLDPointOnRouteFromPlatform:pointOnRoute withRoute:route];
    
    return pointOnRouteInfo;
}

- (WRLDPointOnRoute*) getPointOnRoute:(WRLDRoute*)route
                                point:(CLLocationCoordinate2D)point
{
    return [self getPointOnRoute:route point:point withIndoorMapId:@"" indoorMapFloorId:0];
}


@end
