
#import "WRLDMapView.h"
#import "WRLDProp.h"
#import "WRLDOverlayImpl.h"

#include "EegeoMapApi.h"
#include "EegeoPropsApi.h"
#include "PropCreateParams.h"

@interface WRLDProp () <WRLDOverlayImpl>

@end

@implementation WRLDProp
{
    Eegeo::Api::EegeoPropsApi* m_pPropsApi;
    int m_propId;
}

+ (instancetype)propWithName:(NSString *)name
                  geometryId:(NSString *)geometryId
                    location:(CLLocationCoordinate2D)location
                 indoorMapId:(NSString *)indoorMapId
            indoorMapFloorId:(int)indoorMapFloorId
                   elevation:(CLLocationDistance)elevation
               elevationMode:(WRLDElevationMode)elevationMode
              headingDegrees:(double)headingDegrees
{
    return [[self alloc] initWithName:name
                           geometryId:geometryId
                             location:location
                          indoorMapId:indoorMapId
                     indoorMapFloorId:indoorMapFloorId
                            elevation:elevation
                        elevationMode:elevationMode
                       headingDegrees:headingDegrees];
}

+ (instancetype)propWithName:(NSString *)name
                  geometryId:(NSString *)geometryId
                    location:(CLLocationCoordinate2D)location
                 indoorMapId:(NSString *)indoorMapId
            indoorMapFloorId:(int)indoorMapFloorId
{
    return [[self alloc] initWithName:name
                           geometryId:geometryId
                             location:location
                          indoorMapId:indoorMapId
                     indoorMapFloorId:indoorMapFloorId
                            elevation:0
                        elevationMode:WRLDElevationModeHeightAboveGround
                       headingDegrees:0.0];
}


- (instancetype)initWithName:(NSString *)name
                  geometryId:(NSString *)geometryId
                    location:(CLLocationCoordinate2D)location
                 indoorMapId:(NSString *)indoorMapId
            indoorMapFloorId:(int)indoorMapFloorId
                   elevation:(CLLocationDistance)elevation
               elevationMode:(WRLDElevationMode)elevationMode
              headingDegrees:(double)headingDegrees
{
    if (self = [super init])
    {
        _name = name;
        _geometryId = geometryId;
        _location = location;
        _indoorMapId = indoorMapId;
        _indoorFloorId = indoorMapFloorId;
        _elevation = elevation;
        _elevationMode = elevationMode;
        _headingDegrees = headingDegrees;

        m_propId = 0;
        m_pPropsApi = nil;
    }
    return self;
}

- (std::string)getIndoorMapIdAsStdString
{
    return (_indoorMapId != nil)
        ? std::string([_indoorMapId UTF8String])
        : std::string();
}

- (std::string)getNameAsStdString
{
    return (_name != nil)
    ? std::string([_name UTF8String])
    : std::string();
}

- (std::string)getGeometryIdAsStdString
{
    return (_geometryId != nil)
    ? std::string([_geometryId UTF8String])
    : std::string();
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPropsApi->SetElevation(m_propId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (![self nativeCreated])
    {
        return;
    }

    m_pPropsApi->SetElevationMode(m_propId, [WRLDProp MakeElevationMode:_elevationMode]);
}

#pragma mark - WRLDProp (Private)

+ (Eegeo::Positioning::ElevationMode::Type) MakeElevationMode:(WRLDElevationMode) elevationMode
{
    if (elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveGround)
    {
        return Eegeo::Positioning::ElevationMode::HeightAboveGround;
    }
    return Eegeo::Positioning::ElevationMode::HeightAboveSeaLevel;
}

- (void)createNative:(Eegeo::Api::EegeoMapApi&) mapApi
{
    if ([self nativeCreated])
        return;

    Eegeo::Resources::Interiors::PropCreateParams params(
        [self getIndoorMapIdAsStdString],
        static_cast<int>(_indoorFloorId),
        [self getNameAsStdString],
        _location.latitude,
        _location.longitude,
        static_cast<float>(_elevation),
        [WRLDProp MakeElevationMode:_elevationMode],
        static_cast<float>(_headingDegrees),
        [self getGeometryIdAsStdString]);
   
    m_pPropsApi = &mapApi.GetPropsApi();
    m_propId = m_pPropsApi->CreateProp(params);
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pPropsApi != nullptr)
    {
        m_pPropsApi->DestroyProp(m_propId);
        m_propId = 0;
        m_pPropsApi = nullptr;
    }
}

- (WRLDOverlayId)getOverlayId
{
    return { WRLDOverlayProp, m_propId };
}

- (bool)nativeCreated
{
    return m_propId != 0;
}

@end
