#import "WRLDRouteViewHelper.h"

#include "LatLongAltitude.h"
#include "SpaceHelpers.h"
#include "EarthConstants.h"
#include "Types.h"

@implementation WRLDRouteViewHelper

+ (bool) areApproximatelyEqual:(const CLLocationCoordinate2D &)firstLocation
                secondLocation:(const CLLocationCoordinate2D &)secondLocation
{
    // <= 1mm separation
    const double epsilonSq = 1e-6;
    
    CLLocation *firstLoc = [[CLLocation alloc] initWithLatitude:firstLocation.latitude longitude:firstLocation.longitude];
    CLLocation *secondLoc = [[CLLocation alloc] initWithLatitude:secondLocation.latitude longitude:secondLocation.longitude];
    return  [firstLoc distanceFromLocation:secondLoc] <= epsilonSq;
}

+ (void) removeCoincidentPoints:(const std::vector<CLLocationCoordinate2D> &)coordinates
                         output:(std::vector<CLLocationCoordinate2D> &)output
{
    const std::vector<CLLocationCoordinate2D> &coordinatesFinal = coordinates;
    for(std::vector<CLLocationCoordinate2D>::const_iterator it = coordinatesFinal.begin(); it != coordinates.end(); it++) {

        BOOL isUnique = true;
        CLLocationCoordinate2D firstLocation = *it;
        for(std::vector<CLLocationCoordinate2D>::const_iterator internalIt = it + 1; internalIt != coordinates.end(); internalIt++) {
            CLLocationCoordinate2D secondLocation = *internalIt;
            if([self areApproximatelyEqual:firstLocation secondLocation:secondLocation])
            {
                isUnique = false;
            }
        }

        if (isUnique)
        {
            output.push_back(firstLocation);
        }
    }
}


+ (void) removeCoincidentPointsWithElevations:(std::vector<CLLocationCoordinate2D>&)coordinates
                               pointElevation:(std::vector<CGFloat>&)perPointElevations
                                     ndOutput:(std::vector<CLLocationCoordinate2D>&)output
{
    Eegeo_ASSERT(coordinates.size() == perPointElevations.size());
    std::vector<std::pair<CLLocationCoordinate2D, CGFloat>> zipped;
    zipped.reserve(coordinates.size());
    for (int i = 0; i < coordinates.size(); ++i)
    {
        zipped.push_back(std::make_pair(coordinates[i], perPointElevations[i]));
    }

    const auto newEnd = std::unique(zipped.begin(), zipped.end(), [](const std::pair<CLLocationCoordinate2D, CGFloat>& a, const std::pair<CLLocationCoordinate2D, CGFloat>& b) ->bool {
        const double elevationEpsilon = 1e-3;
            if (![WRLDRouteViewHelper areApproximatelyEqual:a.first secondLocation:b.first])
            {
                return false;
            }
            return std::abs(a.second - b.second) <= elevationEpsilon;
    });
    if (newEnd != zipped.end())
    {
        zipped.erase(newEnd, zipped.end());

        perPointElevations.clear();

        for (const auto& pair : zipped)
        {
            output.push_back(pair.first);
            perPointElevations.push_back(pair.second);
        }
    }
}


+ (WRLDRoutingPolylineCreateParams) MakeNavRoutingPolylineCreateParams:(const std::vector<CLLocationCoordinate2D>&)coordinates
                                                                 color:(UIColor *)color
                                                           indoorMapId:(NSString *)indoorMapId
                                                          ndMapFloorId:(int)indoorMapFloorId
{
    return {coordinates, color, indoorMapId, indoorMapFloorId, {}};
}

+ (WRLDRoutingPolylineCreateParams) MakeNavRoutingPolylineCreateParamsForVerticalLine:(const std::vector<CLLocationCoordinate2D>&)coordinates
                                                                                color:(UIColor *)color
                                                                          indoorMapId:(NSString *)indoorMapId
                                                                           mapFloorId:(int)indoorMapFloorId
                                                                          heightStart:(CGFloat)heightStart
                                                                          ndHeightEnd:(CGFloat)heightEnd
{
    return {coordinates, color, indoorMapId, indoorMapFloorId, {heightStart, heightEnd}};
}

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep *)routeStep
                                                                     andColor:(UIColor *)color
{
    std::vector<WRLDRoutingPolylineCreateParams> results;
    
    std::vector<CLLocationCoordinate2D> pathCoordinates(routeStep.path, routeStep.path + routeStep.pathCount);
    
    std::vector<CLLocationCoordinate2D> uniqueCoordinates;
    [WRLDRouteViewHelper removeCoincidentPoints:pathCoordinates output:uniqueCoordinates];

    if(uniqueCoordinates.size()>1)
    {
        results.push_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParams:uniqueCoordinates color:color indoorMapId:routeStep.indoorId ndMapFloorId:routeStep.indoorFloorId]);
    }
    
    return results;
}

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForRouteDirection:(WRLDRouteStep *)routeStep
                                                                 forwardColor:(UIColor *)forwardColor
                                                                backwardColor:(UIColor *)backwardColor
                                                                   splitIndex:(int)splitIndex
                                                           closestPointOnPath:(CLLocationCoordinate2D)closestPointOnRoute
{
    std::vector<CLLocationCoordinate2D> coordinates(routeStep.path, routeStep.path + routeStep.pathCount);
    std::size_t coordinatesSize = coordinates.size();
    
    bool hasReachedEnd = splitIndex == (routeStep.pathCount-1);
    
    if (hasReachedEnd)
    {
        return [self CreateLinesForRouteDirection:routeStep andColor:backwardColor];
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

        std::vector<CLLocationCoordinate2D> uniqueBackwordCoordinates;
        [WRLDRouteViewHelper removeCoincidentPoints:backwardPath output:uniqueBackwordCoordinates];
        
        std::vector<CLLocationCoordinate2D> uniqueForwardCoordinates;
        [WRLDRouteViewHelper removeCoincidentPoints:forwardPath output:uniqueForwardCoordinates];

        if(backwardPath.size()>1)
        {
            results.emplace_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParams:uniqueBackwordCoordinates
                                                                                 color:backwardColor
                                                                           indoorMapId:routeStep.indoorId
                                                                              ndMapFloorId:routeStep.indoorFloorId]);
        }
        
        if(forwardPath.size()>1)
        {
            results.emplace_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParams:uniqueForwardCoordinates
                                                                                   color:forwardColor
                                                                             indoorMapId:routeStep.indoorId
                                                                            ndMapFloorId:routeStep.indoorFloorId]);
        }
        
        return results;
    }
}

+ (std::vector<WRLDRoutingPolylineCreateParams>) CreateLinesForFloorTransition:(WRLDRouteStep *)routeStep
                                                                   floorBefore:(int)floorBefore
                                                                    floorAfter:(int)floorAfter
                                                                       ndColor:(UIColor *)color
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
    
    results.push_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParamsForVerticalLine:startCoords color:color indoorMapId:routeStep.indoorId mapFloorId:floorBefore heightStart:0 ndHeightEnd:lineHeight]);
    
    results.push_back([WRLDRouteViewHelper MakeNavRoutingPolylineCreateParamsForVerticalLine:endCoords color:color indoorMapId:routeStep.indoorId mapFloorId:floorAfter heightStart:-lineHeight ndHeightEnd:0]);
    
    return results;
}

@end
