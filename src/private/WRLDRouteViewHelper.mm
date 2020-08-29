#import "WRLDRouteViewHelper.h"

#include "LatLongAltitude.h"
#include "SpaceHelpers.h"
#include "EarthConstants.h"

@implementation WRLDRouteViewHelper

+ (bool) areApproximatelyEqualNew:(const CLLocationCoordinate2D &)firstLocation secondLocation:(const CLLocationCoordinate2D &)secondLocation
{
    // <= 1mm separation
    const double epsilonSq = 1e-6;
    
    CLLocation *firstLoc = [[CLLocation alloc] initWithLatitude:firstLocation.latitude longitude:firstLocation.longitude];
    CLLocation *secondLoc = [[CLLocation alloc] initWithLatitude:secondLocation.latitude longitude:secondLocation.longitude];
    return  [firstLoc distanceFromLocation:secondLoc] <= epsilonSq;
}

+ (void) removeCoincidentPoints:(const std::vector<CLLocationCoordinate2D> &)coordinates output:(std::vector<CLLocationCoordinate2D> &)output
{
    const std::vector<CLLocationCoordinate2D> &coordinatesFinal = coordinates;
    for(std::vector<CLLocationCoordinate2D>::const_iterator it = coordinatesFinal.begin(); it != coordinates.end(); it++) {

        BOOL isUnique = true;
        CLLocationCoordinate2D firstLocation = *it;
        for(std::vector<CLLocationCoordinate2D>::const_iterator internalIt = it + 1; internalIt != coordinates.end(); internalIt++) {
            CLLocationCoordinate2D secondLocation = *internalIt;
            if([self areApproximatelyEqualNew:firstLocation secondLocation:secondLocation])
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


@end
