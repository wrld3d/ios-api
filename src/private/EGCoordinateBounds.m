// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#import <CoreLocation/CoreLocation.h>
#import "EGCoordinateBounds.h"

EGCoordinateBounds EGCoordinateBoundsMake(CLLocationCoordinate2D sw,
                                          CLLocationCoordinate2D ne)
{
    EGCoordinateBounds bounds;
    bounds.sw = sw;
    bounds.ne = ne;
    return bounds;
}

EGCoordinateBounds EGCoordinateBoundsFromCoordinatesMake(CLLocationCoordinate2D* coordinates,
                                                         NSUInteger count)
{
    EGCoordinateBounds bounds;
    
    if(count == 0)
    {
        bounds.sw = bounds.ne = CLLocationCoordinate2DMake(0.f, 0.f);
        return bounds;
    }
    
    
    bounds.sw = bounds.ne = CLLocationCoordinate2DMake(coordinates[0].latitude, coordinates[0].longitude);
    
    for(NSUInteger i = 1; i < count; ++ i)
    {
        CLLocationCoordinate2D coordinate = coordinates[i];
        
        if(coordinate.latitude < bounds.sw.latitude)
        {
            bounds.sw.latitude = coordinate.latitude;
        }
        
        if(coordinate.latitude > bounds.ne.latitude)
        {
            bounds.ne.latitude = coordinate.latitude;
        }
        
        if(coordinate.longitude < bounds.sw.longitude)
        {
            bounds.sw.longitude = coordinate.longitude;
        }
        
        if(coordinate.longitude > bounds.ne.longitude)
        {
            bounds.ne.longitude = coordinate.longitude;
        }
    }
    
    return bounds;
}

