
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDPolygon.h"
#import "WRLDOverlayImpl.h"

#include "EegeoPolygonApi.h"
#include "PolygonShapeBuilder.h"

@interface WRLDPolygon () <WRLDOverlayImpl>

@end

@implementation WRLDPolygon
{
    Eegeo::Api::EegeoPolygonApi* m_pPolygonApi;
    int m_polygonId;
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
        
        _color = [UIColor blackColor];
        _elevation = 0;
        _elevationMode = WRLDElevationMode::WRLDElevationModeHeightAboveGround;
        _indoorMapId = indoorMapId;
        _indoorFloorId = floorId;
        
        m_pPolygonApi = nil;
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPolygonApi->SetFillColor(m_polygonId, [self _getColor]);
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

- (std::string)getIndoorMapIdAsStdString
{
    return (_indoorMapId != nil)
        ? std::string([_indoorMapId UTF8String])
        : std::string();
}

- (void)setIndoorMapId:(NSString * _Nonnull)indoorMapId
{
    _indoorMapId = indoorMapId;
    if (![self nativeCreated])
    {
        return;
    }
    
    m_pPolygonApi->SetIndoorMapId(m_polygonId, [self getIndoorMapIdAsStdString]);
}

- (void)setIndoorFloorId:(NSInteger)indoorFloorId
{
    _indoorFloorId = indoorFloorId;
    if (![self nativeCreated])
    {
        return;
    }
    
    m_pPolygonApi->SetIndoorMapFloorId(m_polygonId, _indoorFloorId);
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPolygonApi->SetElevation(m_polygonId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (![self nativeCreated])
    {
        return;
    }

    m_pPolygonApi->SetElevationMode(m_polygonId, [WRLDPolygon MakeElevationMode:_elevationMode]);
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

- (void)createNative:(Eegeo::Api::EegeoMapApi&) mapApi
{
    if ([self nativeCreated])
        return;

    Eegeo::Shapes::Polygons::PolygonShapeBuilder builder;
    builder
        .SetFillColor([self _getColor])
        .SetElevationMode([WRLDPolygon MakeElevationMode:_elevationMode])
        .SetElevation(_elevation)
        .SetOuterRing(m_outerRing);
    
    for (auto innerRing : m_innerRings)
    {
        builder.AddInnerRing(innerRing);
    }
    
    if (_indoorMapId != nil)
    {
        builder.SetIndoorMap(std::string([_indoorMapId UTF8String]), static_cast<int>(_indoorFloorId));
    }
    
    m_pPolygonApi = &mapApi.GetPolygonApi();
    m_polygonId = m_pPolygonApi->CreateShape(builder.Build());
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pPolygonApi != nullptr)
    {
        m_pPolygonApi->DestroyShape(m_polygonId);
        m_polygonId = false;
        m_pPolygonApi = nullptr;
    }
}

- (WRLDOverlayId)getOverlayId
{
    return { WRLDOverlayPolygon, m_polygonId };
}

- (bool)nativeCreated
{
    return m_polygonId != 0;
}

@end
