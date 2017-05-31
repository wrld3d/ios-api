
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDMarker.h"

#include "MarkerBuilder.h"
#include "EegeoMarkersApi.h"
#include "MarkerTypes.h"

@interface WRLDMarker ()

@property (nonatomic, readwrite, copy) NSString* styleName;

@property (nonatomic, readwrite, copy) NSString* indoorMapId;

@property (nonatomic, readwrite) NSInteger indoorFloorId;

@end

@implementation WRLDMarker
{
    Eegeo::Api::EegeoMarkersApi* m_pMarkersApi;
    int m_markerId;
    bool m_addedToMapView;
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
        _iconKey = @"misc";
        _indoorMapId = indoorMapId;
        _indoorFloorId = floorId;

        m_pMarkersApi = NULL;
        m_addedToMapView = false;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
    if (!m_addedToMapView) return;
    m_pMarkersApi->SetLocation(m_markerId, _coordinate.latitude, _coordinate.longitude);
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    if (!m_addedToMapView) return;
    m_pMarkersApi->SetAnchorHeight(m_markerId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (!m_addedToMapView) return;
    if (_elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveGround)
    {
        m_pMarkersApi->SetAnchorHeightMode(m_markerId, Eegeo::Markers::AnchorHeight::Type::HeightAboveGround);
    }
    else if (_elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveSeaLevel)
    {
        m_pMarkersApi->SetAnchorHeightMode(m_markerId, Eegeo::Markers::AnchorHeight::Type::HeightAboveSeaLevel);
    }
}

- (void)setDrawOrder:(NSInteger)drawOrder
{
    _drawOrder = drawOrder;
    if (!m_addedToMapView) return;
    m_pMarkersApi->SetSubPriority(m_markerId, static_cast<int>(_drawOrder));
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (!m_addedToMapView) return;
    m_pMarkersApi->SetLabelText(m_markerId, [_title UTF8String]);
}

- (void)setUserData:(NSString *)userData
{
    _userData = userData;
}

- (void)setIconKey:(NSString *)iconKey
{
    _iconKey = iconKey;
    if (!m_addedToMapView) return;
    m_pMarkersApi->SetIconKey(m_markerId, [_iconKey UTF8String]);
}

#pragma mark - WRLDMarker (Private)

- (void)addToMapView:(WRLDMapView *) mapView
{   
    if (m_addedToMapView) return;
    m_pMarkersApi = &[mapView getMapApi].GetMarkersApi();
    
    Eegeo::Markers::MarkerBuilder builder;
    builder.SetLocation(_coordinate.latitude, _coordinate.longitude);
    builder.SetAnchorHeight(static_cast<float>(_elevation));
    builder.SetSubPriority(static_cast<int>(_drawOrder));
    if (_elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveGround)
    {
        builder.SetAnchorHeightMode(Eegeo::Markers::AnchorHeight::Type::HeightAboveGround);
    }
    else if (_elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveSeaLevel)
    {
        builder.SetAnchorHeightMode(Eegeo::Markers::AnchorHeight::Type::HeightAboveSeaLevel);
    }
    builder.SetLabelText([_title UTF8String]);
    builder.SetLabelStyle([_styleName UTF8String]);
    builder.SetLabelIcon([_iconKey UTF8String]);
    builder.SetInterior([_indoorMapId UTF8String], static_cast<int>(_indoorFloorId));
    m_markerId = m_pMarkersApi->CreateMarker(builder.Build());
    m_addedToMapView = true;
}

- (void)removeFromMapView
{
    if (m_addedToMapView && m_pMarkersApi != NULL)
    {
        m_pMarkersApi->DestroyMarker(m_markerId);
        m_addedToMapView = false;
    }
}

- (int)getId
{
    return m_markerId;
}

- (bool)isOnMapView
{
    return m_addedToMapView;
}

@end
