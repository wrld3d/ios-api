
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDPolygon.h"

#include "EegeoGeofenceApi.h"
#include "GeofenceModel.h"

@interface WRLDPolygon ()

@end

@implementation WRLDPolygon
{
    Eegeo::Api::EegeoGeofenceApi* m_pGeofenceApi;
    int m_polygonId;
    bool m_addedToMapView;
    std::vector<Eegeo::Space::LatLongAltitude> m_outerPolygon;
    std::vector<std::vector<Eegeo::Space::LatLongAltitude>> m_interiorPolygons;
}

+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                            interiorPolygons:@[]];
}

+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
                      interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons;
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                            interiorPolygons:interiorPolygons];
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coords
                              count:(NSUInteger)count
                   interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons;
{
    if (self = [super init])
    {
        m_outerPolygon.reserve(count);
        for (int i = 0; i < count; ++i)
        {
            Eegeo::Space::LatLongAltitude coord = Eegeo::Space::LatLongAltitude::FromDegrees(coords[i].latitude, coords[i].longitude, 0);
            m_outerPolygon.push_back(coord);
        }
        
        m_interiorPolygons.reserve([interiorPolygons count]);
        for (WRLDPolygon *polygon in interiorPolygons)
        {
            m_interiorPolygons.push_back([polygon _getOuterPolygon]);
        }
        
        _color = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f];
        _elevation = 0;
        _elevationMode = WRLDElevationMode::WRLDElevationModeHeightAboveGround;
        
        m_pGeofenceApi = NULL;
        m_addedToMapView = false;
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    if (!m_addedToMapView) return;
    m_pGeofenceApi->SetGeofenceColor(m_polygonId, [self _getColor]);
}

- (Eegeo::v4)_getColor
{
    CGFloat red, green, blue, alpha;
    [_color getRed:&red
             green:&green
              blue:&blue
             alpha:&alpha];
    return Eegeo::v4(static_cast<float>(red), static_cast<float>(green), static_cast<float>(blue), static_cast<float>(alpha));
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    if (!m_addedToMapView) return;
    m_pGeofenceApi->SetGeofenceAltitude(m_polygonId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (!m_addedToMapView) return;
    bool offsetFromSeaLevel = _elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveSeaLevel;
    m_pGeofenceApi->SetGeofenceIsOffsetFromSeaLevel(m_polygonId, offsetFromSeaLevel);
}

- (const std::vector<Eegeo::Space::LatLongAltitude>)_getOuterPolygon
{
    return m_outerPolygon;
}

#pragma mark - WRLDPolygon (Private)

- (void)addToMapView:(WRLDMapView *) mapView
{
    if (m_addedToMapView) return;
    m_pGeofenceApi = &[mapView getMapApi].GetGeofenceApi();
    
    Eegeo::v4 color = [self _getColor];
    bool offsetFromSeaLevel = _elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveSeaLevel;
    
    m_polygonId = m_pGeofenceApi->CreateGeofence(m_outerPolygon, m_interiorPolygons, color, offsetFromSeaLevel, _elevation);
    m_addedToMapView = true;
}

- (void)removeFromMapView
{
    if (m_addedToMapView && m_pGeofenceApi != NULL)
    {
        m_pGeofenceApi->RemoveGeofence(m_polygonId);
        m_addedToMapView = false;
    }
}

- (int)getId
{
    return m_polygonId;
}

- (bool)isOnMapView
{
    return m_addedToMapView;
}

@end
