#import "WRLDCoordinateWithAltitude.h"

WRLDCoordinateWithAltitude WRLDCoordinateWithAltitudeMake(CLLocationCoordinate2D coordinate, CLLocationDistance altitude)
{
    WRLDCoordinateWithAltitude coordWithAltitude;
    coordWithAltitude.coordinate = coordinate;
    coordWithAltitude.altitude = altitude;
    return coordWithAltitude;
}
