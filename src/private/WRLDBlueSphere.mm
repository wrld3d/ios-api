#import "WRLDBlueSphere.h"
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"

#include "EegeoBlueSphereApi.h"
#include "LatLongAltitude.h"
#include "MathFunc.h"

@implementation WRLDBlueSphere
{
    Eegeo::Api::EegeoBlueSphereApi* m_pBlueSphereApi;
}

- (instancetype)initWithMapView:(WRLDMapView *)mapView
{
    m_pBlueSphereApi = &[mapView getMapApi].GetBlueSphereApi();
    
    if (self = [super init])
    {
        [self setCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)];
        [self setDirection: 0.0];
        [self setIndoorMap:@"" withIndoorMapFloorId:0];
        [self setElevation:0.0];
    }

    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
    m_pBlueSphereApi->SetCoordinate(Eegeo::Space::LatLong::FromDegrees(_coordinate.latitude, _coordinate.longitude));
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    m_pBlueSphereApi->SetElevation(_elevation);
}

- (void)setDirection:(CLLocationDirection)direction
{
    _direction = direction;
    m_pBlueSphereApi->SetHeadingRadians(static_cast<float>(Eegeo::Math::Deg2Rad(_direction)));
}

- (void)setIndoorFloorId:(NSInteger)indoorFloorId
{
    [self setIndoorMap:_indoorMapId withIndoorMapFloorId:indoorFloorId];
}

- (void)setIndoorMap:(NSString * _Nonnull)indoorMapId
withIndoorMapFloorId:(NSInteger)indoorMapFloorId
{
    _indoorMapId = indoorMapId;
    _indoorFloorId = indoorMapFloorId;
    m_pBlueSphereApi->SetIndoorMap([_indoorMapId UTF8String], static_cast<int>(_indoorFloorId));
}

- (void)setEnabled:(bool)enabled
{
    _enabled = enabled;
    m_pBlueSphereApi->SetEnabled(_enabled);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
            direction:(CLLocationDirection) direction
{
    [self setCoordinate:coordinate];
    [self setDirection:direction];
}


@end
