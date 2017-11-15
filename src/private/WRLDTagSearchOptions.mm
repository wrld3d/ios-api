
#import "WRLDTagSearchOptions.h"

@interface WRLDTagSearchOptions ()

@end

@implementation WRLDTagSearchOptions
{
    NSString* m_query;
    CLLocationCoordinate2D m_center;
    BOOL m_useRadius;
    double m_radius;
    BOOL m_useNumber;
    NSInteger m_number;
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

@end


