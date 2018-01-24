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
}

- (instancetype) init {
    self = [super init];
    if (self)
    {
        m_color = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        m_shouldCreateView = true;
    }
    return self;
}

- (void) highlightBuildingAtLocation:(CLLocationCoordinate2D)location
{
    m_selectionLocation = location;
    m_selectionMode = WRLDBuildingHighlightSelectAtLocation;
}

- (void) highlightBuildingAtScreenPoint:(CGPoint)screenPoint
{
    m_selectionScreenPoint = screenPoint;
    m_selectionMode = WRLDBuildingHighlightSelectAtScreenPoint;
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

@end
