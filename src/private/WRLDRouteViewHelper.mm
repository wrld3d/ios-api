#import "WRLDRouteViewHelper.h"

#include "LatLongAltitude.h"
#include "SpaceHelpers.h"
#include "EarthConstants.h"

@implementation WRLDRouteViewHelper

+ (bool) areApproximatelyEqualNew:(CLLocationCoordinate2D)firstLocation secondLocation:(CLLocationCoordinate2D)secondLocation
{
    // <= 1mm separation
    const double epsilonSq = 1e-6;
    
    Eegeo::Space::LatLong firstLoc = Eegeo::Space::LatLong::FromDegrees(firstLocation.latitude, firstLocation.longitude);
    Eegeo::Space::LatLong secondLoc = Eegeo::Space::LatLong::FromDegrees(secondLocation.latitude, secondLocation.longitude);

    return Eegeo::Space::SpaceHelpers::GreatCircleDistance(firstLoc, secondLoc, Eegeo::Space::EarthConstants::Radius) <= epsilonSq;
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
