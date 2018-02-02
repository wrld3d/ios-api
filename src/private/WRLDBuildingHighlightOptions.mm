#import "WRLDBuildingHighlightOptions.h"
#import "WRLDBuildingHighlightOptions+Private.h"

@interface WRLDBuildingHighlightOptions ()

@end

@implementation WRLDBuildingHighlightOptions
{
    CLLocationCoordinate2D m_selectionLocation;
    CGPoint m_selectionScreenPoint;
    UIColor* m_color;
    WRLDBuildingHighlightSelectionMode m_selectionMode;
    Boolean m_shouldCreateView;
    WRLDScreenProperties m_screenProperties;
}

+ (instancetype) highlightOptionsWithLocation:(CLLocationCoordinate2D)location
{
    return [[self alloc] initWithLocation:location];
}

+ (instancetype) highlightOptionsWithScreenPoint:(CGPoint)screenPoint
                                screenProperties:(WRLDScreenProperties)screenProperties;
{
    return [[self alloc] initWithScreenPoint:screenPoint
                            screenProperties:screenProperties];
}

- (instancetype) initWithLocation:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self)
    {
        m_selectionLocation = location;
        m_selectionMode = WRLDBuildingHighlightSelectAtLocation;
        m_color = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        m_shouldCreateView = true;
    }
    return self;
}

- (instancetype) initWithScreenPoint:(CGPoint)screenPoint
                    screenProperties:(WRLDScreenProperties)screenProperties
{
    self = [super init];
    if (self)
    {
        m_selectionScreenPoint = screenPoint;
        m_screenProperties = screenProperties;
        m_selectionMode = WRLDBuildingHighlightSelectAtScreenPoint;
        m_color = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        m_shouldCreateView = true;
    }
    return self;
}

- (void) setColor:(UIColor*)color
{
    m_color = color;
}

- (void) informationOnly
{
    m_shouldCreateView = false;
}

- (WRLDBuildingHighlightSelectionMode) selectionMode
{
    return m_selectionMode;
}

- (CLLocationCoordinate2D) selectionLocation
{
    return m_selectionLocation;
}

- (CGPoint) selectionScreenPoint
{
    return m_selectionScreenPoint;
}

- (UIColor*) color
{
    return m_color;
}

- (Boolean) shouldCreateView
{
    return m_shouldCreateView;
}

- (WRLDScreenProperties) screenProperties
{
    return m_screenProperties;
}

@end
