
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDMarker.h"
#import "WRLDOverlayImpl.h"

#include "MarkerBuilder.h"
#include "EegeoMarkersApi.h"
#include "MarkerTypes.h"

@interface WRLDMarker () <WRLDOverlayImpl>

@property (nonatomic, readwrite, copy) NSString* indoorMapId;

@property (nonatomic, readwrite) NSInteger indoorFloorId;

@end

@implementation WRLDMarker
{
    Eegeo::Api::EegeoMarkersApi* m_pMarkersApi;
    int m_markerId;
}

+ (const Eegeo::Positioning::ElevationMode::Type) ToPositioningElevationMode:(WRLDElevationMode)elevationMode
{
    return (elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveGround)
        ? Eegeo::Positioning::ElevationMode::HeightAboveGround
        : Eegeo::Positioning::ElevationMode::HeightAboveSeaLevel;
}

+ (instancetype)markerAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [[self alloc] initWithCoordinate:coordinate
                             andIndoorMapId:@""
                                 andFloorId:0];
}

+ (instancetype)markerAtCoordinate:(CLLocationCoordinate2D)coordinate
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
        _drawOrder = 0;
        _title = @"";
        _styleName = @"marker_default";
        _userData = @"";
        _iconKey = @"pin";
        _indoorMapId = indoorMapId;
        _indoorFloorId = floorId;

        m_pMarkersApi = NULL;
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
    m_pMarkersApi->SetLocation(m_markerId, _coordinate.latitude, _coordinate.longitude);
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    if (![self nativeCreated])
    {
        return;
    }
    m_pMarkersApi->SetElevation(m_markerId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (![self nativeCreated])
    {
        return;
    }

    m_pMarkersApi->SetElevationMode(m_markerId, [WRLDMarker ToPositioningElevationMode:elevationMode]);
}

- (void)setDrawOrder:(NSInteger)drawOrder
{
    _drawOrder = drawOrder;
    if (![self nativeCreated])
    {
        return;
    }
    m_pMarkersApi->SetSubPriority(m_markerId, static_cast<int>(_drawOrder));
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (![self nativeCreated])
    {
        return;
    }
    m_pMarkersApi->SetLabelText(m_markerId, [_title UTF8String]);
}

- (void)setUserData:(NSString *)userData
{
    _userData = userData;
}

- (void)setIconKey:(NSString *)iconKey
{
    _iconKey = iconKey;
    if (![self nativeCreated])
    {
        return;
    }
    m_pMarkersApi->SetIconKey(m_markerId, [_iconKey UTF8String]);
}

#pragma mark - WRLDMarker (Private)

- (void)createNative:(Eegeo::Api::EegeoMapApi&) mapApi
{   
    if ([self nativeCreated])
    {
        return;
    }
    
    m_pMarkersApi = &mapApi.GetMarkersApi();
    
    const Eegeo::Markers::MarkerCreateParams& markerCreateParams = Eegeo::Markers::MarkerBuilder()
        .SetLocation(_coordinate.latitude, _coordinate.longitude)
        .SetElevation(_elevation)
        .SetSubPriority(static_cast<int>(_drawOrder))
        .SetElevationMode([WRLDMarker ToPositioningElevationMode:_elevationMode])
        .SetLabelText([_title UTF8String])
        .SetLabelStyle([_styleName UTF8String])
        .SetLabelIcon([_iconKey UTF8String])
        .SetInterior([_indoorMapId UTF8String], static_cast<int>(_indoorFloorId))
        .Build();
    
    m_markerId = m_pMarkersApi->CreateMarker(markerCreateParams);
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pMarkersApi != nullptr)
    {
        m_pMarkersApi->DestroyMarker(m_markerId);
        m_markerId = 0;
        m_pMarkersApi = nullptr;
    }
}

- (WRLDOverlayId)getOverlayId
{
    return { WRLDOverlayMarker, m_markerId };
}

- (bool)nativeCreated
{
    return m_markerId != 0;
}

@end
