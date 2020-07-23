#import "WRLDRouteViewHelper.h"

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

@end
