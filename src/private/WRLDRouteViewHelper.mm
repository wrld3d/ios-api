#import "WRLDRouteViewHelper.h"

@implementation WRLDRouteViewHelper

bool AreApproximatelyEqual(
    const CLLocationCoordinate2D& first,
    const CLLocationCoordinate2D& second
)
{
    // <= 1mm separation
    const double epsilonSq = 1e-6;

    CLLocation *firstLoc = [[CLLocation alloc] initWithLatitude:first.latitude longitude:first.longitude];
    CLLocation *secondLoc = [[CLLocation alloc] initWithLatitude:second.latitude longitude:second.longitude];
    return  [firstLoc distanceFromLocation:secondLoc] <= epsilonSq;
}

bool AreCoordinateElevationPairApproximatelyEqual(
    std::pair<CLLocationCoordinate2D, CGFloat>& a,
    std::pair<CLLocationCoordinate2D, CGFloat>& b
    )
{
    const double elevationEpsilon = 1e-3;

    if (!AreApproximatelyEqual(a.first, b.first))
    {
        return false;
    }

    return std::abs(a.second - b.second) <= elevationEpsilon;
}

+ (void) removeCoincidentPoints:(std::vector<CLLocationCoordinate2D>&)coordinates
{
    coordinates.erase(
        std::unique(coordinates.begin(), coordinates.end(), AreApproximatelyEqual),
        coordinates.end());
}

+ (void) removeCoincidentPointsWithElevations:(std::vector<CLLocationCoordinate2D>&)coordinates
                            perPointElevation:(std::vector<CGFloat>&)perPointElevations
{
    Eegeo_ASSERT(coordinates.size() == perPointElevations.size());
    std::vector<std::pair<CLLocationCoordinate2D, CGFloat>> zipped;
    zipped.reserve(coordinates.size());
    for (int i = 0; i < coordinates.size(); ++i)
    {
        zipped.push_back(std::make_pair(coordinates[i], perPointElevations[i]));
    }
    
    const auto newEnd = std::unique(zipped.begin(), zipped.end(), AreCoordinateElevationPairApproximatelyEqual);
    if (newEnd != zipped.end())
    {
        zipped.erase(newEnd, zipped.end());

        coordinates.clear();
        perPointElevations.clear();

        for (const auto& pair : zipped)
        {
            coordinates.push_back(pair.first);
            perPointElevations.push_back(pair.second);
        }
    }
}


+ (WRLDRoutingPolylineCreateParams) MakeNavRoutingPolylineCreateParams:(const std::vector<CLLocationCoordinate2D>&)coordinates
                                                                 color:(UIColor*)color
                                                           indoorMapId:(NSString*)indoorMapId
                                                            mapFloorId:(int)indoorMapFloorId
{
    return {coordinates, color, indoorMapId, indoorMapFloorId, {}};
}

+ (WRLDRoutingPolylineCreateParams) MakeNavRoutingPolylineCreateParamsForVerticalLine:(const std::vector<CLLocationCoordinate2D>&)coordinates
                                                                                color:(UIColor*)color
                                                                          indoorMapId:(NSString*)indoorMapId
                                                                           mapFloorId:(int)indoorMapFloorId
                                                                          heightStart:(CGFloat)heightStart
                                                                            heightEnd:(CGFloat)heightEnd
{
    return {coordinates, color, indoorMapId, indoorMapFloorId, {heightStart, heightEnd}};
}

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep*)routeStep
                                                                        color:(UIColor*)color
{
    std::vector<WRLDRoutingPolylineCreateParams> results;
    
    std::vector<CLLocationCoordinate2D> pathCoordinates(routeStep.path, routeStep.path + routeStep.pathCount);
    
    [WRLDRouteViewHelper removeCoincidentPoints:pathCoordinates];

    if(pathCoordinates.size()>1)
    {
        results.push_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParams:pathCoordinates color:color indoorMapId:routeStep.indoorId mapFloorId:routeStep.indoorFloorId]);
    }
    
    return results;
}

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep*)routeStep
                                                                 forwardColor:(UIColor*)forwardColor
                                                                backwardColor:(UIColor*)backwardColor
                                                                   splitIndex:(int)splitIndex
                                                           closestPointOnPath:(CLLocationCoordinate2D)closestPointOnRoute
{
    std::vector<CLLocationCoordinate2D> coordinates(routeStep.path, routeStep.path + routeStep.pathCount);
    std::size_t coordinatesSize = coordinates.size();
    
    bool hasReachedEnd = splitIndex == (routeStep.pathCount-1);
    
    if (hasReachedEnd)
    {
        return [self CreateLinesForRouteDirection:routeStep color:backwardColor];
    }
    else
    {
        std::vector<WRLDRoutingPolylineCreateParams> results;
        
        std::vector<CLLocationCoordinate2D> backwardPath;
        std::vector<CLLocationCoordinate2D> forwardPath;
        
        auto forwardPathSize = coordinatesSize - (splitIndex + 1);
        forwardPath.reserve(forwardPathSize + 1); //Extra space for the split point
        
        auto backwardPathSize = coordinatesSize - forwardPathSize;
        backwardPath.reserve(backwardPathSize + 1); //Extra space for the split point
        
        //Forward path starts with the split point
        forwardPath.emplace_back(closestPointOnRoute);
        
        for (int i = 0; i < coordinatesSize; i++)
        {
            if(i<=splitIndex)
            {
                backwardPath.emplace_back(coordinates[i]);
            }
            else
            {
                forwardPath.emplace_back(coordinates[i]);
            }
        }
        
        //Backward path ends with the split point
        backwardPath.emplace_back(closestPointOnRoute);

        [WRLDRouteViewHelper removeCoincidentPoints:backwardPath];
        [WRLDRouteViewHelper removeCoincidentPoints:forwardPath];

        if(backwardPath.size()>1)
        {
            results.emplace_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParams:backwardPath
                                                                                   color:backwardColor
                                                                             indoorMapId:routeStep.indoorId
                                                                              mapFloorId:routeStep.indoorFloorId]);
        }
        
        if(forwardPath.size()>1)
        {
            results.emplace_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParams:forwardPath
                                                                                   color:forwardColor
                                                                             indoorMapId:routeStep.indoorId
                                                                              mapFloorId:routeStep.indoorFloorId]);
        }
        
        return results;
    }
}

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForFloorTransition:(WRLDRouteStep*)routeStep
                                                                   floorBefore:(int)floorBefore
                                                                    floorAfter:(int)floorAfter
                                                                         color:(UIColor*)color
{
    CGFloat verticalLineHeight = 5.0;
    CGFloat lineHeight = (floorAfter > floorBefore) ? verticalLineHeight : -verticalLineHeight;
    std::vector<WRLDRoutingPolylineCreateParams> results;

    uint coordinateCount = static_cast<uint>(routeStep.pathCount);
    Eegeo_ASSERT(coordinateCount >= 2, "Can't make a floor transition line with a single point");
    
    std::vector<CLLocationCoordinate2D> coordinates(routeStep.path, routeStep.path + routeStep.pathCount);
    
    std::vector<CLLocationCoordinate2D> startCoords;
    startCoords.push_back(coordinates.at(0));
    startCoords.push_back(coordinates.at(1));

    std::vector<CLLocationCoordinate2D> endCoords;
    endCoords.push_back(coordinates.at(coordinateCount-2));
    endCoords.push_back(coordinates.at(coordinateCount-1));
    
    results.push_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParamsForVerticalLine:startCoords color:color indoorMapId:routeStep.indoorId mapFloorId:floorBefore heightStart:0 heightEnd:lineHeight]);
    
    results.push_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParamsForVerticalLine:endCoords color:color indoorMapId:routeStep.indoorId mapFloorId:floorAfter heightStart:-lineHeight heightEnd:0]);
    
    return results;
}

@end
