
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDMarker.h"

#include "MarkerBuilder.h"
#include "EegeoMarkersApi.h"
#include "MarkerTypes.h"


@implementation WRLDMarker
{
    Eegeo::Api::EegeoMarkersApi* m_pMarkersApi;
    NSInteger m_markerId;
}

- (instancetype)initWithMarkerOptions:(WRLDMarkerOptions *)markerOptions
                      andAddToMapView:(WRLDMapView*) mapView
{
    self = [super init];
    
    m_pMarkersApi = &[mapView getMapApi].GetMarkersApi();

    Eegeo::Markers::MarkerBuilder builder;
    builder.SetLocation(markerOptions.coordinate.latitude, markerOptions.coordinate.longitude);
    builder.SetAnchorHeight(markerOptions.elevation);
    builder.SetSubPriority(markerOptions.drawOrder);
    if (_elevationMode == MarkerElevationMode::HeightAboveGround)
    {
        builder.SetAnchorHeightMode(Eegeo::Markers::AnchorHeight::Type::HeightAboveGround);
    }
    else if (_elevationMode == MarkerElevationMode::HeightAboveSeaLevel)
    {
        builder.SetAnchorHeightMode(Eegeo::Markers::AnchorHeight::Type::HeightAboveSeaLevel);
    }
    builder.SetLabelText([markerOptions.title UTF8String]);
    builder.SetLabelStyle([markerOptions.styleName UTF8String]);
    builder.SetLabelIcon([markerOptions.iconKey UTF8String]);
    m_markerId = m_pMarkersApi->CreateMarker(builder.Build());
    
    _coordinate = markerOptions.coordinate;
    _elevation = markerOptions.elevation;
    _elevationMode = markerOptions.elevationMode;
    _drawOrder = markerOptions.drawOrder;
    _title = markerOptions.title;
    _styleName = markerOptions.styleName;
    _userData = markerOptions.userData;
    _iconKey = markerOptions.iconKey;
    
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
    m_pMarkersApi->SetLocation(m_markerId, _coordinate.latitude, _coordinate.longitude);
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    m_pMarkersApi->SetAnchorHeight(m_markerId, _elevation);
}

- (void)setElevationMode:(MarkerElevationMode)elevationMode
{
    _elevationMode = elevationMode;
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
    m_pMarkersApi->SetSubPriority(m_markerId, _drawOrder);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    m_pMarkersApi->SetLabelText(m_markerId, [_title UTF8String]);
}

- (void)setUserData:(NSString *)userData
{
    _userData = userData;
}

- (void)setIconKey:(NSString *)iconKey
{
    _iconKey = iconKey;
    m_pMarkersApi->SetIconKey(m_markerId, [_iconKey UTF8String]);
}

@end
