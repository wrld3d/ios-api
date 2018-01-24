
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDPolyline.h"
#import "WRLDOverlayImpl.h"

#include "EegeoPolylineApi.h"
#include "PolylineShapeBuilder.h"
#include "InteriorId.h"

@interface WRLDPolyline () <WRLDOverlayImpl>

@end

@implementation WRLDPolyline
{
    Eegeo::Api::EegeoPolylineApi* m_pPolylineApi;
    int m_polylineId;

    std::vector<Eegeo::Space::LatLong> m_coords;
    std::vector<double> m_perPointElevations;
}

+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                                 onIndoorMap:nil
                                     onFloor:0
            ];
}


+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords
                                  count:(NSUInteger)count
                            onIndoorMap:(NSString *)indoorMapId
                                onFloor:(NSInteger)floorId
{
    return [[self alloc] initWithCoordinates:coords
                                       count:count
                                 onIndoorMap:indoorMapId
                                     onFloor:floorId
            ];
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coords
                              count:(NSUInteger)count
                        onIndoorMap:(NSString *)indoorMapId
                            onFloor:(NSInteger)floorId
{
    if (self = [super init])
    {
        m_coords.reserve(count);
        for (int i = 0; i < count; ++i)
        {
            const CLLocationCoordinate2D& coord = coords[i];
            m_coords.emplace_back(Eegeo::Space::LatLong::FromDegrees(coord.latitude, coord.longitude));
        }
        
        _color = [UIColor blackColor];
        _lineWidth = 10.0f;
        _miterLimit = 10.0f;
        _elevation = 0;
        _elevationMode = WRLDElevationMode::WRLDElevationModeHeightAboveGround;
        _indoorMapId = indoorMapId;
        _indoorFloorId = floorId;
        
        for( int i = 0; i < count; ++i)
        {
            m_perPointElevations.push_back(0);
        }
        m_pPolylineApi = nil;
    }
    return self;
}

- (void)setPerPointElevations:(CGFloat*)perPointElevations count:(NSUInteger)count
{
    long int min = MIN(m_coords.size(), count);
    for (int i = 0; i < min; ++i)
    {
        m_perPointElevations[i] = (double)perPointElevations[i];
    }
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPolylineApi->SetFillColor(m_polylineId, [self _getColor]);
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


- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPolylineApi->SetThickness(m_polylineId, static_cast<float>(_lineWidth));
}

- (void)setMiterLimit:(CGFloat)miterLimit
{
    _miterLimit = miterLimit;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPolylineApi->SetMiterLimit(m_polylineId, static_cast<float>(_miterLimit));
}

- (void)setScalesWithMap:(Boolean)scalesWithMap
{
    _scalesWithMap = scalesWithMap;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPolylineApi->SetScalesWithMap(m_polylineId, _scalesWithMap);
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
    
    m_pPolylineApi->SetIndoorMapId(m_polylineId, [self getIndoorMapIdAsStdString]);
}

- (void)setIndoorFloorId:(NSInteger)indoorFloorId
{
    _indoorFloorId = indoorFloorId;
    if (![self nativeCreated])
    {
        return;
    }
    
    m_pPolylineApi->SetIndoorMapFloorId(m_polylineId, static_cast<int>(_indoorFloorId));
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    if (![self nativeCreated])
    {
        return;
    }
    m_pPolylineApi->SetElevation(m_polylineId, _elevation);
}

- (void)setElevationMode:(WRLDElevationMode)elevationMode
{
    _elevationMode = elevationMode;
    if (![self nativeCreated])
    {
        return;
    }
    
    m_pPolylineApi->SetElevationMode(m_polylineId, [WRLDPolyline MakeElevationMode:_elevationMode]);
}


#pragma mark - WRLDPolyline (Private)

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
    {
        return;
    }
    
    const Eegeo::Positioning::ElevationMode::Type elevationMode = [WRLDPolyline MakeElevationMode:_elevationMode];
    
    const std::string& indoorMapId = [self getIndoorMapIdAsStdString];
    
     const auto& createParams = Eegeo::Shapes::Polylines::PolylineShapeBuilder()
        .SetCoordinates(m_coords)
        .SetFillColor([self _getColor])
        .SetThickness(static_cast<float>(_lineWidth))
        .SetMiterLimit(static_cast<float>(_miterLimit))
        .SetShouldScaleWithMap(_scalesWithMap)
        .SetElevationMode(elevationMode)
        .SetElevation(_elevation)
        .SetIndoorMap(indoorMapId, static_cast<int>(_indoorFloorId))
        .SetPerPointElevations(m_perPointElevations)
        .Build();
    
    m_pPolylineApi = &mapApi.GetPolylineApi();
    m_polylineId = m_pPolylineApi->CreateShape(createParams);
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pPolylineApi != nullptr)
    {
        m_pPolylineApi->DestroyShape(m_polylineId);
        m_polylineId = 0;
        m_pPolylineApi = nullptr;
    }
}

- (WRLDOverlayId)getOverlayId
{
    return { WRLDOverlayPolyline, m_polylineId };
}

- (bool)nativeCreated
{
    return m_polylineId != 0;
}

@end
