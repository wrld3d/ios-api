
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

+ (instancetype)marker
{
    return [[self alloc] initProperties];
}

- (instancetype)initProperties
{
    if (self = [super init])
    {
        _elevationMode = MarkerElevationMode::HeightAboveSeaLevel;
        _title = @"";
        _styleName = @"marker_default";
        _userData = @"";
        _iconKey = @"misc";
        _indoorMapId = @"";

        m_pMarkersApi = NULL;
        m_addedToMapView = false;
    }
    return self;
}

- (void)addToMapView:(WRLDMapView *) mapView
{
    if (m_addedToMapView) return;
    m_pMarkersApi = &[mapView getMapApi].GetMarkersApi();

    Eegeo::Markers::MarkerBuilder builder;
    builder.SetLocation(_coordinate.latitude, _coordinate.longitude);
    builder.SetAnchorHeight(_elevation);
    builder.SetSubPriority(_drawOrder);
    if (_elevationMode == MarkerElevationMode::HeightAboveGround)
    {
        builder.SetAnchorHeightMode(Eegeo::Markers::AnchorHeight::Type::HeightAboveGround);
    }
    else if (_elevationMode == MarkerElevationMode::HeightAboveSeaLevel)
    {
        builder.SetAnchorHeightMode(Eegeo::Markers::AnchorHeight::Type::HeightAboveSeaLevel);
    }
    builder.SetLabelText([_title UTF8String]);
    builder.SetLabelStyle([_styleName UTF8String]);
    builder.SetLabelIcon([_iconKey UTF8String]);
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

- (void)setElevationMode:(MarkerElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (!m_addedToMapView) return;
    if (_elevationMode == MarkerElevationMode::HeightAboveGround)
    {
        m_pMarkersApi->SetAnchorHeightMode(m_markerId, Eegeo::Markers::AnchorHeight::Type::HeightAboveGround);
    }
    else if (_elevationMode == MarkerElevationMode::HeightAboveSeaLevel)
    {
        m_pMarkersApi->SetAnchorHeightMode(m_markerId, Eegeo::Markers::AnchorHeight::Type::HeightAboveSeaLevel);
    }
}

- (void)setDrawOrder:(NSInteger)drawOrder
{
    _drawOrder = drawOrder;
    if (!m_addedToMapView) return;
    m_pMarkersApi->SetSubPriority(m_markerId, _drawOrder);
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

@end
