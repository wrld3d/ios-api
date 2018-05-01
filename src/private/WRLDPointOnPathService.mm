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

- (WRLDPointOnRouteInfo*) makeWRLDPointOnRouteInfoFromPlatform:(Eegeo::PointOnPath::PointOnRouteInfo)pointOnRouteInfo withRoute:(WRLDRoute*)route
{
    WRLDPointOnRouteInfo* newPointOnRouteInfo = [[WRLDPointOnRouteInfo alloc] init];
    
    newPointOnRouteInfo.projectedPoint = CLLocationCoordinate2DMake(pointOnRouteInfo.m_projectedPoint.GetLatitudeInDegrees(),
                                                                    pointOnRouteInfo.m_projectedPoint.GetLongitudeInDegrees());
    
    newPointOnRouteInfo.distanceToTargetPointSqr = pointOnRouteInfo.m_distanceToTargetPointSqr;
    
    newPointOnRouteInfo.fractionAlongRoutePath = pointOnRouteInfo.m_fractionAlongRoutePath;
    
    newPointOnRouteInfo.routeSection = route.sections[pointOnRouteInfo.m_routeSectionIndex];
    
    newPointOnRouteInfo.routeStep = newPointOnRouteInfo.routeSection.steps[pointOnRouteInfo.m_routeStepIndex];
    
    return newPointOnRouteInfo;
}

- (CLLocationCoordinate2D) getPointOnPath:(CLLocationCoordinate2D* )path
                           count:(NSInteger)count
                           point:(CLLocationCoordinate2D)point
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    
    Eegeo::Space::LatLong projectedPoint = m_pointOnPathApi->GetPointOnPath(latLng, [self makeLatLongPath:path count:count]);
    
    return CLLocationCoordinate2DMake(projectedPoint.GetLatitudeInDegrees(), projectedPoint.GetLongitudeInDegrees());
}

- (CGFloat) getPointFractionAlongPath:(CLLocationCoordinate2D *)path
                                count:(NSInteger)count
                                point:(CLLocationCoordinate2D)point
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    return (CGFloat)m_pointOnPathApi->GetPointFractionAlongPath(latLng, [self makeLatLongPath:path count:count]);
}

- (WRLDPointOnRouteInfo*) getPointOnRoute:(WRLDRoute*)route
                                point:(CLLocationCoordinate2D)point
{
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(point.latitude, point.longitude);
    Eegeo::Routes::Webservice::RouteData* routeData = [self makeRouteDataFromWRLDRoute:route];
    
    Eegeo::PointOnPath::PointOnRouteInfo pointOnRoute = m_pointOnPathApi->GetPointOnRoute(latLng, routeData);

    WRLDPointOnRouteInfo* pointOnRouteInfo = [self makeWRLDPointOnRouteInfoFromPlatform:pointOnRoute withRoute:route];
    
    return pointOnRouteInfo;
}


@end
