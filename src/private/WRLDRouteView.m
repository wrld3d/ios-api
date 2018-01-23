#import "WRLDRouteView.h"
#import "WRLDRoute+Private.h"
#import "WRLDRouteViewOptions.h"
#import "WRLDRouteSection.h"
#import "WRLDRouteSection+Private.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface WRLDRouteView ()

@end

static double VERTICAL_LINE_HEIGHT = 5.0;

@implementation WRLDRouteView
{
    WRLDMapView* m_map;
    WRLDRoute* m_route;
    NSMutableArray* m_polylines;
    BOOL m_currentlyOnMap;
    CGFloat m_width;
    UIColor* m_color;
    CGFloat m_miterLimit;
}

- (instancetype)initWithMapView:(WRLDMapView*)map
                          route:(WRLDRoute*)route
                        options:(WRLDRouteViewOptions*)options
{
    if (self = [super init])
    {
        m_polylines = [[NSMutableArray alloc] init];
        m_map = map;
        m_route = route;
        m_width = options.getWidth;
        m_color = options.getColor;
        m_miterLimit = options.getMiterLimit;
        [self addToMap];
    }
    
    return self;
}

- (void) addToMap
{
    for (WRLDRouteSection* section in m_route.sections)
    {
        int i = 0;
        for (WRLDRouteStep* step in section.steps)
        {
            i++;
            if (step.pathCount < 2)
            {
                continue;
            }
            
            if (step.isMultiFloor)
            {
                bool isValidTransition = i > 0 && i < (section.steps.count - 1) && step.isIndoors;
                
                if (!isValidTransition)
                {
                    continue;
                }
                
                WRLDRouteStep* stepBefore = [section.steps objectAtIndex:i-1];
                WRLDRouteStep* stepAfter = [section.steps objectAtIndex:i+1];
                
                [self addLinesForFloorTransition:step stepBefore:stepBefore stepAfter:stepAfter];
            }
            else
            {
                [self addLinesForRouteStep:step];
            }
        }
    }
}

- (WRLDPolyline*) makeVerticalLine:(WRLDRouteStep*)step
                             floor:(NSInteger)floor
                            height:(CGFloat)height
{
   WRLDPolyline* polyline = [WRLDPolyline polylineWithCoordinates:step.path count:step.pathCount onIndoorMap:step.indoorId onFloor:floor];
    CGFloat elevations[2];
    elevations[0] = (CGFloat)0;
    elevations[1] = (CGFloat)height;
    [polyline setPerPointElevations:elevations count:2];
    return polyline;
}

- (void) addLinesForRouteStep:(WRLDRouteStep*)step
{
     WRLDPolyline* polyline;
    
    if (step.isIndoors)
    {
        polyline = [WRLDPolyline polylineWithCoordinates:step.path
                                                   count:step.pathCount
                                             onIndoorMap:step.indoorId
                                                 onFloor:step.indoorFloorId];
    }
    else
    {
        polyline = [WRLDPolyline polylineWithCoordinates:step.path
                                                   count:step.pathCount];
    }
    
    polyline.color = m_color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
}

- (void) addLinesForFloorTransition:(WRLDRouteStep*)step
                         stepBefore:(WRLDRouteStep*)stepBefore
                          stepAfter:(WRLDRouteStep*)stepAfter
{
    NSInteger floorBefore = stepBefore.indoorFloorId;
    NSInteger floorAfter = stepAfter.indoorFloorId;
    CGFloat lineHeight = (floorAfter > floorBefore) ? (CGFloat)VERTICAL_LINE_HEIGHT : -(CGFloat)VERTICAL_LINE_HEIGHT;
    
    WRLDPolyline* polyline = [self makeVerticalLine:step floor:floorBefore height:lineHeight];
                polyline.color = m_color;
                polyline.lineWidth = m_width;
                polyline.miterLimit = m_miterLimit;
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
    
    polyline = [self makeVerticalLine:step floor:floorAfter height:-lineHeight];
    polyline.color = m_color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
}

- (void) removeFromMap
{
    for(WRLDPolyline* poly in m_polylines)
    {
        [m_map removeOverlay:poly];
    }
}

- (void) setWidth:(CGFloat)width
{
    m_width = width;
    for(WRLDPolyline* polyline in m_polylines)
    {
        [polyline setLineWidth:m_width];
    }
}

- (void) setColor:(UIColor*)color
{
    m_color = color;
    for(WRLDPolyline* polyline in m_polylines)
    {
        [polyline setColor:m_color];
    }
}

- (void) setMiterLimit:(CGFloat)miterLimit
{
    m_miterLimit = miterLimit;
    for(WRLDPolyline* polyline in m_polylines)
    {
        [polyline setMiterLimit:m_miterLimit];
    }
}

@end
