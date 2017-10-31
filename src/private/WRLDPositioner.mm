
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDPositioner.h"
#import "WRLDPositioner+Private.h"

#include "EegeoPositionerApi.h"
#include "PositionerTypes.h"

@implementation WRLDPositioner
{
    Eegeo::Api::EegeoPositionerApi* m_pPositionersApi;
    int m_positionerId;
    CGPoint m_screenPoint;
    WRLDCoordinateWithAltitude m_transformedPoint;
}

+ (instancetype)positionerAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [[self alloc] initWithCoordinate:coordinate
                             andIndoorMapId:@""
                                 andFloorId:0];
}

+ (instancetype)positionerAtCoordinate:(CLLocationCoordinate2D)coordinate
                       inIndoorMap:(NSString *)indoorMapId
                           onFloor:(NSInteger)floorId;
{
    return [[self alloc] initWithCoordinate:coordinate
                             andIndoorMapId:indoorMapId
                                 andFloorId:floorId];
}

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                    andIndoorMapId:(NSString *)indoorMapId
                        andFloorId:(NSInteger)floorId
{
    if (self = [super init])
    {
        _coordinate = coordinate;
        _elevation = 0;
        _elevationMode = WRLDElevationMode::WRLDElevationModeHeightAboveGround;
        _indoorMapId = indoorMapId;
        _indoorFloorId = floorId;
        
        m_pPositionersApi = NULL;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPositionersApi->SetLocation(m_positionerId, _coordinate.latitude, _coordinate.longitude);
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPositionersApi->SetElevation(m_positionerId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (![self nativeCreated])
    {
        return;
    }
    
    //m_pPositionersApi->SetElevationMode(m_positionerId, ToPositioningElevationMode(elevationMode));
}

- (nullable CGPoint *) screenPointOrNull
{
    Eegeo::v3 screenPoint;
    if([self nativeCreated] && m_pPositionersApi->TryScreenProject(m_positionerId, screenPoint))
    {
        m_screenPoint.x = screenPoint.x;
        m_screenPoint.y = screenPoint.y;
        return &m_screenPoint;
    }

    return nil;
}


- (nullable WRLDCoordinateWithAltitude *) transformedPointOrNull
{
    Eegeo::dv3 transformedPoint;
    
    if([self nativeCreated] && m_pPositionersApi->TryGetTransformedPoint(m_positionerId, transformedPoint))
    {
        Eegeo::Space::LatLongAltitude latLngAlt = Eegeo::Space::LatLongAltitude::FromECEF(transformedPoint);

        m_transformedPoint.coordinate.latitude = latLngAlt.GetLatitudeInDegrees();
        m_transformedPoint.coordinate.longitude = latLngAlt.GetLongitudeInDegrees();
        m_transformedPoint.altitude = latLngAlt.GetAltitude();

        return &m_transformedPoint;
    }

    return nil;
}

- (BOOL) screenPointProjectionDefined
{
    return ![self behindGlobeHorizon] && [self screenPointOrNull] != nil;
}

- (BOOL) behindGlobeHorizon
{
    if([self nativeCreated])
    {
        return m_pPositionersApi->IsBehindGlobeHorizon(m_positionerId);
    }

    return false;
}

#pragma mark - WRLDPositioner (Private)

- (void)createNative:(Eegeo::Api::EegeoMapApi&) mapApi
{
    if ([self nativeCreated])
    {
        return;
    }

    m_pPositionersApi = &mapApi.GetPositionerApi();

    const Eegeo::Positioners::PositionerModelCreateParams& positionerCreateParams = Eegeo::Positioners::PositionerBuilder()
    .SetCoordinate(_coordinate.latitude, _coordinate.longitude)
    .SetElevation(_elevation)
    .SetElevationMode(ToPositioningElevationMode(_elevationMode))
    .SetIndoorMap([_indoorMapId UTF8String], static_cast<int>(_indoorFloorId))
    .Build();

    m_positionerId = m_pPositionersApi->CreatePositioner(positionerCreateParams);
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pPositionersApi != nil)
    {
        m_pPositionersApi->DestroyPositioner(m_positionerId);
        m_positionerId = 0;
        m_pPositionersApi = nil;
    }
}

- (bool)nativeCreated
{
    return m_positionerId != 0;
}

- (int)getPositionerId
{
    return m_positionerId;
}

- (void)notifyPositionerProjectionChanged
{
    [self.delegate onPositionerChanged: self];
}

@end

