#import "WRLDRouteViewHelper.h"

#include "LatLongAltitude.h"
#include "SpaceHelpers.h"
#include "EarthConstants.h"

@implementation WRLDRouteViewHelper

+ (bool) areApproximatelyEqual:(CLLocation*)firstLocation secondLocation:(CLLocation*)secondLocation
{
    // <= 1mm separation
    const double epsilonSq = 1e-6;
    return [firstLocation distanceFromLocation:secondLocation] <= epsilonSq;
}

+ (NSMutableArray*) removeCoincidentPoints:(NSMutableArray*) coordinates
{
    NSMutableArray* uniqueCoordinates = [[NSMutableArray alloc] init];

    for(int i=0;i<coordinates.count;i++)
    {
        CLLocation* firstLocation = [coordinates objectAtIndex:i];
        bool isUnique = true;
        for(int j=i+1; j<coordinates.count;j++)
        {
            CLLocation* secondLocation = [coordinates objectAtIndex:j];
            if ([self areApproximatelyEqual:firstLocation secondLocation:secondLocation])
            {
                isUnique = false;
            }
        }
        if (isUnique)
        {
            [uniqueCoordinates addObject:firstLocation];
        }
    }
    return uniqueCoordinates;
}

+ (bool) areApproximatelyEqualNew:(CLLocationCoordinate2D)firstLocation secondLocation:(CLLocationCoordinate2D)secondLocation
{
    // <= 1mm separation
    const double epsilonSq = 1e-6;
    
    Eegeo::Space::LatLong firstLoc = Eegeo::Space::LatLong::FromDegrees(firstLocation.latitude, firstLocation.longitude);
    Eegeo::Space::LatLong secondLoc = Eegeo::Space::LatLong::FromDegrees(secondLocation.latitude, secondLocation.longitude);

    return Eegeo::Space::SpaceHelpers::GreatCircleDistance(firstLoc, secondLoc, Eegeo::Space::EarthConstants::Radius) <= epsilonSq;
    
//    CLLocation *first = [[CLLocation alloc] initWithLatitude:firstLocation.latitude longitude:firstLocation.longitude];
//    CLLocation *second = [[CLLocation alloc] initWithLatitude:secondLocation.latitude longitude:secondLocation.longitude];
//    return [first distanceFromLocation:second] <= epsilonSq;
}

+ (std::vector<CLLocationCoordinate2D>) removeCoincidentPointsFromVector:(std::vector<CLLocationCoordinate2D>) coordinates
{
//    NSMutableArray* uniqueCoordinates = [[NSMutableArray alloc] init];
    
//    for(int i=0; i<coordinates.count; i++)
//    {
//        CLLocation* firstLocation = [coordinates objectAtIndex:i];
//        bool isUnique = true;
//        for(int j=i+1; j<coordinates.count;j++)
//        {
//            CLLocation* secondLocation = [coordinates objectAtIndex:j];
//            if ([self areApproximatelyEqual:firstLocation secondLocation:secondLocation])
//            {
//                isUnique = false;
//            }
//        }
//        if (isUnique)
//        {
//            [uniqueCoordinates addObject:firstLocation];
//        }
//    }
//    return uniqueCoordinates;
    
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
