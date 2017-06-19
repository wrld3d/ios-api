
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDPolygon.h"

#include "EegeoGeofenceApi.h"
#include "GeofenceModel.h"
#include "GeofenceBuilder.h"

@interface WRLDPolygon ()

@end

@implementation WRLDPolygon
{
    Eegeo::Api::EegeoGeofenceApi* m_pGeofenceApi;
    int m_polygonId;
    bool m_addedToMapView;
    std::vector<Eegeo::Space::LatLong> m_outerRing;
    std::vector<std::vector<Eegeo::Space::LatLong> > m_innerRings;
}

+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                            interiorPolygons:@[]
                                 onIndoorMap:nil
                                     onFloor:0
                            ];
}

+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
                      interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons;
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                            interiorPolygons:interiorPolygons
                                 onIndoorMap:nil
                                     onFloor:0
                            ];
}

+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
                           onIndoorMap:(NSString *)indoorMapId
                               onFloor:(NSInteger)floorId
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                            interiorPolygons:@[]
                                 onIndoorMap:indoorMapId
                                     onFloor:floorId
                                     ];
}

+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                count:(NSUInteger)count
                     interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons
                          onIndoorMap:(NSString *)indoorMapId
                              onFloor:(NSInteger)floorId
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                            interiorPolygons:interiorPolygons
                                 onIndoorMap:indoorMapId
                                     onFloor:floorId
                            ];
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coords
                              count:(NSUInteger)count
                   interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons
                        onIndoorMap:(NSString *)indoorMapId
                            onFloor:(NSInteger)floorId
{
    if (self = [super init])
    {
        m_outerRing.reserve(count);
        for (int i = 0; i < count; ++i)
        {
            const CLLocationCoordinate2D& coord = coords[i];
            m_outerRing.emplace_back(Eegeo::Space::LatLong::FromDegrees(coord.latitude, coord.longitude));
        }
        
        m_innerRings.reserve([interiorPolygons count]);
        for (WRLDPolygon *polygon in interiorPolygons)
        {
            m_innerRings.push_back([polygon _getOuterRing]);
        }
        
        _color = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f];
        _elevation = 0;
        _elevationMode = WRLDElevationMode::WRLDElevationModeHeightAboveGround;
        _indoorMapId = indoorMapId;
        _indoorFloorId = floorId;
        
        m_pGeofenceApi = NULL;
        m_addedToMapView = false;
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    if (!m_addedToMapView)
    {
        return;
    }
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
    if (!m_addedToMapView)
    {
        return;
    }
    m_pGeofenceApi->SetGeofenceElevation(m_polygonId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (!m_addedToMapView)
    {
        return;
    }

    m_pGeofenceApi->SetGeofenceElevationMode(m_polygonId, [WRLDPolygon MakeElevationMode:_elevationMode]);
}

- (const std::vector<Eegeo::Space::LatLong>&)_getOuterRing
{
    return m_outerRing;
}

#pragma mark - WRLDPolygon (Private)

+ (Eegeo::Positioning::ElevationMode::Type) MakeElevationMode:(WRLDElevationMode) elevationMode
{
    if (elevationMode == WRLDElevationMode::WRLDElevationModeHeightAboveGround)
    {
        return Eegeo::Positioning::ElevationMode::HeightAboveGround;
    }
    return Eegeo::Positioning::ElevationMode::HeightAboveSeaLevel;
}

- (void)addToMapView:(WRLDMapView *) mapView
{
    if (m_addedToMapView)
        return;
    
    
    Eegeo::Data::Geofencing::GeofenceBuilder geofenceBuilder;
    geofenceBuilder.SetOuterRing(m_outerRing);
    
    for (auto innerRing : m_innerRings)
    {
        geofenceBuilder.AddInnerRing(innerRing);
    }
    
    const Eegeo::Positioning::ElevationMode::Type elevationMode = [WRLDPolygon MakeElevationMode:_elevationMode];
    
    geofenceBuilder
        .SetPolygonColor([self _getColor])
        .SetElevationMode(elevationMode)
        .SetElevation(_elevation);
    
    if (_indoorMapId != nil)
    {
        geofenceBuilder.SetIndoorMap(std::string([_indoorMapId UTF8String]), static_cast<int>(_indoorFloorId));
    }
    const Eegeo::Data::Geofencing::GeofenceCreateParams& createParams = geofenceBuilder.Build();
    
    
    m_pGeofenceApi = &[mapView getMapApi].GetGeofenceApi();
    m_polygonId = m_pGeofenceApi->CreateGeofence(createParams);
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
