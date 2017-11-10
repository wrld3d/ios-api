
#import "WRLDTextSearchOptions.h"

@interface WRLDTextSearchOptions ()

@end

@implementation WRLDTextSearchOptions
{
    NSString* m_query;
    CLLocationCoordinate2D m_center;
    BOOL m_useRadius;
    double m_radius;
    BOOL m_useNumber;
    NSInteger m_number;
    BOOL m_useMinScore;
    double m_minScore;
    BOOL m_useIndoorMapId;
    NSString* m_indoorMapId;
    BOOL m_useIndoorMapFloorId;
    NSInteger m_indoorMapFloorId;
    BOOL m_useFloorDropoff;
    NSInteger m_floorDropoff;
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        m_query = @"";
        m_center = CLLocationCoordinate2DMake(0, 0);
        m_useRadius = false;
        m_radius = 0.0;
        m_useNumber = false;
        m_number = 0;
        m_useMinScore = false;
        m_minScore = 0;
        m_useIndoorMapId = false;
        m_indoorMapId = @"";
        m_useIndoorMapFloorId = false;
        m_indoorMapFloorId = 0;
        m_useFloorDropoff = false;
        m_floorDropoff = 0;
    }
    return self;
}

- (NSString*)getQuery
{
    return m_query;
}

- (void)setQuery:(NSString*)query
{
    m_query = query;
}

- (CLLocationCoordinate2D)getCenter
{
    return m_center;
}

- (void)setCenter:(CLLocationCoordinate2D)center
{
    m_center = center;
}

- (BOOL)usesRadius
{
    return m_useRadius;
}

- (double)getRadius
{
    return m_radius;
}

- (void)setRadius:(double)radius
{
    m_useRadius = true;
    m_radius = radius;
}

- (BOOL)usesNumber
{
    return m_useNumber;
}

- (NSInteger)getNumber
{
    return m_number;
}

- (void)setNumber:(NSInteger)number
{
    m_useNumber = true;
    m_number = number;
}

- (BOOL)usesMinScore
{
    return m_useMinScore;
}

- (double)getMinScore
{
    return m_minScore;
}

- (void)setMinScore:(double)minScore
{
    m_useMinScore = true;
    m_minScore = minScore;
}

- (BOOL)usesIndoorMapId
{
    return m_useIndoorMapId;
}

- (NSString*)getIndoorMapId
{
    return m_indoorMapId;
}

- (void)setIndoorMapId:(NSString*)indoorMapId
{
    m_useIndoorMapId = true;
    m_indoorMapId = indoorMapId;
}

- (BOOL)usesIndoorMapFloorId
{
    return m_useIndoorMapFloorId;
}

- (NSInteger)getIndoorMapFloorId
{
    return m_indoorMapFloorId;
}

- (void)setIndoorMapFloorId:(NSInteger)indoorMapFloorId
{
    m_useIndoorMapFloorId = true;
    m_indoorMapFloorId = indoorMapFloorId;
}

- (BOOL)usesFloorDropoff
{
    return m_useFloorDropoff;
}

- (NSInteger)getFloorDropoff
{
    return m_floorDropoff;
}

- (void)setFloorDropoff:(NSInteger)floorDropoff
{
    m_useFloorDropoff = true;
    m_floorDropoff = floorDropoff;
}

@end


