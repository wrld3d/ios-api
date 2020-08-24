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

+ (std::vector<CLLocationCoordinate2D>) removeCoincidentPoints:(std::vector<CLLocationCoordinate2D>) coordinates
{
    std::vector<CLLocationCoordinate2D> returnVector;
    for(std::vector<CLLocationCoordinate2D>::iterator it = coordinates.begin(); it != coordinates.end(); it++) {
            
        BOOL isUnique = true;
        CLLocationCoordinate2D firstLocation = *it;
        for(std::vector<CLLocationCoordinate2D>::iterator internalIt = it + 1; internalIt != coordinates.end(); internalIt++) {
            CLLocationCoordinate2D secondLocation = *internalIt;
            if([self areApproximatelyEqualNew:firstLocation secondLocation:secondLocation])
            {
                isUnique = false;
            }
        }
        
        if (isUnique)
        {
            returnVector.push_back(firstLocation);
        }
        
    }
    
    return returnVector;
}


@end
