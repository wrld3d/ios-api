#include <math.h>

#import "WRLDMapCamera.h"

@implementation WRLDMapCamera

+ (BOOL)supportsSecureCoding
{
    return YES;
}

+ (instancetype)camera
{
    return [[self alloc] init];
}

+ (instancetype)cameraLookingAtCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                              fromEyeCoordinate:(CLLocationCoordinate2D)eyeCoordinate
                                    eyeAltitude:(CLLocationDistance)eyeAltitude
{
    CLLocationDistance distance = 0;
    CLLocationDirection heading = 0;
    CGFloat pitch = 0;
    if (CLLocationCoordinate2DIsValid(centerCoordinate) && CLLocationCoordinate2DIsValid(eyeCoordinate)) {
        CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
        CLLocation *eyeLocation = [[CLLocation alloc] initWithLatitude:eyeCoordinate.latitude longitude:eyeCoordinate.longitude];
        CLLocationDistance groundEyeToCenter = [eyeLocation distanceFromLocation:centerLocation];
        
        distance = sqrt(pow(eyeAltitude, 2) + pow(groundEyeToCenter, 2));
        
        pitch = static_cast<float>((M_PI_2 - atan(eyeAltitude / groundEyeToCenter))) * 180 / static_cast<float>(M_PI);
        
        const double centerLatRadians = centerCoordinate.latitude * M_PI / 180;
        const double centerLongRadians = centerCoordinate.longitude * M_PI / 180;
        const double eyeLatRadians = eyeCoordinate.latitude * M_PI / 180;
        const double eyeLongRadians = eyeCoordinate.longitude * M_PI / 180;
        double deltaLong = centerLongRadians - eyeLongRadians;
        double y = sin(deltaLong) * cos(centerLatRadians);
        double x = cos(eyeLatRadians) * sin(centerLatRadians) - sin(eyeLatRadians)* cos(centerLatRadians) * cos(deltaLong);
        double tempHeading = atan2(y, x);
        heading = fmod(tempHeading + 2 * M_PI, 2 * M_PI) * 180 / M_PI;
    }
    
    return [[self alloc] initWithCenterCoordinate:centerCoordinate
                                         distance:distance
                                            pitch:pitch
                                          heading:heading];
}

+ (instancetype)cameraLookingAtCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                   fromDistance:(CLLocationDistance)distance
                                          pitch:(CGFloat)pitch
                                        heading:(CLLocationDirection)heading
{
    return [[self alloc] initWithCenterCoordinate:centerCoordinate
                                         distance:distance
                                            pitch:pitch
                                          heading:heading];
}

- (instancetype)initWithCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                distance:(CLLocationDistance)distance
                                   pitch:(CGFloat)pitch
                                 heading:(CLLocationDirection)heading
{
    if (self = [super init])
    {
        _centerCoordinate = centerCoordinate;
        _distance = distance;
        _pitch = pitch;
        _heading = heading;
    }
    return self;
}

- (CLLocationDistance)altitude
{
    return cos(_pitch * M_PI / 180) * _distance;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:_centerCoordinate.latitude forKey:@"centerCoordinateLatitude"];
    [encoder encodeDouble:_centerCoordinate.longitude forKey:@"centerCoordinateLongitude"];
    [encoder encodeDouble:_distance forKey:@"distance"];
    [encoder encodeDouble:_pitch forKey:@"pitch"];
    [encoder encodeDouble:_heading forKey:@"heading"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        _centerCoordinate = CLLocationCoordinate2DMake([decoder decodeDoubleForKey:@"centerCoordinateLatitude"],
                                                       [decoder decodeDoubleForKey:@"centerCoordinateLongitude"]);
        _distance = [decoder decodeDoubleForKey:@"distance"];
        _pitch = [decoder decodeFloatForKey:@"pitch"];
        _heading = [decoder decodeDoubleForKey:@"heading"];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return [[WRLDMapCamera allocWithZone:zone] initWithCenterCoordinate:_centerCoordinate
                                                               distance:_distance
                                                                  pitch:_pitch
                                                                heading:_heading];
}

@end
