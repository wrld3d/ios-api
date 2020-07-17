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
                
                [self addLinesForFloorTransition:step stepBefore:stepBefore stepAfter:stepAfter ofColor:m_color];
            }
            else
            {
                [self addLinesForRouteStep:step ofColor:m_color];
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
                      ofColor:(UIColor*)color
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
    
    polyline.color = color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
}

- (void) addLinesForFloorTransition:(WRLDRouteStep*)step
                         stepBefore:(WRLDRouteStep*)stepBefore
                          stepAfter:(WRLDRouteStep*)stepAfter
                            ofColor:(UIColor*)color
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
    polyline.color = color;
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
    [m_polylines removeAllObjects];
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

-(void) addLinesForRouteStep:(WRLDRouteStep*)step
                forwardColor:(UIColor *)fColor
               backwardColor:(UIColor*)bColor
                  splitIndex:(int) sIndex
         closestPointOnRoute:(CLLocationCoordinate2D) closestPoint
{
    
    
    CLLocationCoordinate2D* coordinates = step.path;
    int coordinatesSize = step.pathCount;

    bool hasReachedEnd = sIndex == (coordinatesSize-1);

    if (hasReachedEnd)
    {
        [self addLinesForRouteStep:step ofColor:bColor];
    }
    else
    {
        int actualBackwordPathCount = sIndex;
        int actualForwordPathCount = actualBackwordPathCount;
        int newBackwordPathCount = actualBackwordPathCount + 1;
        int newForwordPathCount = actualForwordPathCount + 1;

        CLLocationCoordinate2D* backwardPath = new CLLocationCoordinate2D[newBackwordPathCount];
        CLLocationCoordinate2D* forwardPath = new CLLocationCoordinate2D[newForwordPathCount];
                
        for (int i =0; i< sIndex; i++)
        {
            backwardPath[i] = coordinates[i];
        }
        
        if(sIndex == 0 && coordinatesSize == 2)
        {
            backwardPath[0] = coordinates[0];
        }
        
        backwardPath[newBackwordPathCount-1] =  closestPoint;
        forwardPath[0] =  closestPoint;
        int index = 0;
        
        for (int i = sIndex; i < coordinatesSize; i++)
        {
            forwardPath[index+1] = coordinates[i];
        }
        
        if (step.isIndoors)
        {
            [self addLinesForRoutePath:backwardPath pathCount:newBackwordPathCount ofColor:bColor indoorId:step.indoorId floorId:step.indoorFloorId];
            [self addLinesForRoutePath:forwardPath pathCount:newForwordPathCount ofColor:fColor indoorId:step.indoorId floorId:step.indoorFloorId];
        }
        else
        {
            [self addLinesForRoutePath:backwardPath pathCount:newBackwordPathCount ofColor:bColor];
            [self addLinesForRoutePath:forwardPath pathCount:newForwordPathCount ofColor:fColor];
        }
    }
}

-(void) addLinesForRoutePath:(CLLocationCoordinate2D*)path pathCount:(int)count ofColor:(UIColor*)color
{
    WRLDPolyline* polyline = [WRLDPolyline polylineWithCoordinates:path count: count];
    
    polyline.color = color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
}
-(void) addLinesForRoutePath:(CLLocationCoordinate2D*)path pathCount:(int)count ofColor:(UIColor*)color indoorId:(NSString*)indoorId floorId:(int)floorId
{
    WRLDPolyline* polyline = [WRLDPolyline polylineWithCoordinates:path count: count onIndoorMap:indoorId
    onFloor:floorId];
    
    polyline.color = color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
}

@end
