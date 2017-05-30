
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDPolygon.h"

#include "EegeoGeofenceApi.h"
#include "GeofenceModel.h"

@interface WRLDPolygon ()

@property (nonatomic) NSUInteger count;
@property (nonatomic) Eegeo::v4 color;

@end

@implementation WRLDPolygon
{
    Eegeo::Api::EegeoGeofenceApi* m_pGeofenceApi;
    int m_polygonId;
    bool m_addedToMapView;
}

+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coordinates
                                 count:(NSUInteger)count;
{
    return [[self alloc] initWithCoordinates:coordinates
                                       count:count];
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coordinates
                              count:(NSUInteger)count;
{
    if (self = [super init])
    {
        _coordinates = coordinates;
        _count = count;
        _color = Eegeo::v4(0, 0, 1, 0.5);
        _elevation = 0;
        _elevationMode = WRLDElevationMode::WRLDElevationModeHeightAboveGround;
        
        m_pGeofenceApi = NULL;
        m_addedToMapView = false;
    }
    return self;
}

- (void)setColor:(double)r g:(double)g b:(double)b
{
    [self setColor:r g:g b:b a:1];
}

- (void)setColor:(double)r g:(double)g b:(double)b a:(double)a
{
    _color = Eegeo::v4(r, g, b, a);
    if (!m_addedToMapView) return;
    m_pGeofenceApi->SetGeofenceColor(m_polygonId, _color);
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

#pragma mark - WRLDPolygon (Private)

- (void)addToMapView:(WRLDMapView *) mapView
{
    if (m_addedToMapView) return;
    m_pGeofenceApi = &[mapView getMapApi].GetGeofenceApi();
    std::vector<Eegeo::Space::LatLongAltitude> points;
    
    for (int i = 0; i < _count; ++i)
    {
        Eegeo::Space::LatLongAltitude point = Eegeo::Space::LatLongAltitude::FromDegrees(_coordinates[i].latitude, _coordinates[i].longitude, 0);
        points.push_back(point);
    }
    
    bool offsetFromSeaLevel = _elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveSeaLevel;
    
    m_polygonId = m_pGeofenceApi->CreateGeofence(points, _color, offsetFromSeaLevel, _elevation);
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
