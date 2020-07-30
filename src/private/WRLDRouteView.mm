#import "WRLDRouteView.h"
#import "WRLDRoute+Private.h"
#import "WRLDRouteViewOptions.h"
#import "WRLDRouteSection.h"
#import "WRLDRouteSection+Private.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "WRLDRouteViewHelper.h"

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
    UIColor* m_forwardPathColor;
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
        m_forwardPathColor = options.getForwardPathColor;
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

-(void) addLinesForRouteStep:(WRLDRouteStep*)step
          closestPointOnPath:(CLLocationCoordinate2D)closestPoint
                  splitIndex:(int)sIndex
{
    
    
    CLLocationCoordinate2D* coordinates = step.path;
    int coordinatesSize = step.pathCount;

    bool hasReachedEnd = sIndex == (coordinatesSize-1);

    if (hasReachedEnd)
    {
        [self addLinesForRouteStep:step];
    }
    else
    {
        NSMutableArray *backPathArray = [[NSMutableArray alloc] init];
        NSMutableArray *forwardPathArray = [[NSMutableArray alloc] init];

        for (int i=0; i<sIndex;i++)
        {
            [backPathArray addObject:[[CLLocation alloc] initWithLatitude:coordinates[i].latitude longitude:coordinates[i].longitude]];
        }
        
        if(sIndex == 0 && coordinatesSize == 2)
        {
            [backPathArray addObject:[[CLLocation alloc] initWithLatitude:coordinates[0].latitude longitude:coordinates[0].longitude]];
        }
        
        CLLocation *closestLoc = [[CLLocation alloc] initWithLatitude:closestPoint.latitude longitude:closestPoint.longitude];
        [backPathArray addObject:closestLoc];
        [forwardPathArray addObject:closestLoc];
        
        for (int i = sIndex; i<coordinatesSize; i++)
        {
            [forwardPathArray addObject:[[CLLocation alloc] initWithLatitude:coordinates[i].latitude longitude:coordinates[i].longitude]];
        }
        
        backPathArray = [WRLDRouteViewHelper removeCoincidentPoints:backPathArray];
        forwardPathArray = [WRLDRouteViewHelper removeCoincidentPoints:forwardPathArray];
        
        int backwardPathSize = (int) backPathArray.count;
        int forwardPathSize = (int) forwardPathArray.count;
        CLLocationCoordinate2D* backwardPath = new CLLocationCoordinate2D[backwardPathSize];
        CLLocationCoordinate2D* forwardPath = new CLLocationCoordinate2D[forwardPathSize];
        
        for (int i=0; i<backwardPathSize;i++)
        {
            CLLocation *loc = [backPathArray objectAtIndex:i];
            backwardPath[i] = loc.coordinate;
        }
        
        for (int i=0; i<forwardPathSize;i++)
        {
            CLLocation *loc = [forwardPathArray objectAtIndex:i];
            forwardPath[i] = loc.coordinate;
        }
        
        if (backwardPathSize >= 2)
        {
            if (step.isIndoors)
            {
                [self addLinesForRoutePath:backwardPath pathCount:backwardPathSize ofColor:m_color indoorId:step.indoorId floorId:step.indoorFloorId];
            }
            else
            {
                [self addLinesForRoutePath:backwardPath pathCount:backwardPathSize ofColor:m_color];
            }
        }
        
        if (forwardPathSize >= 2)
        {
            if (step.isIndoors)
            {
                [self addLinesForRoutePath:forwardPath pathCount:forwardPathSize ofColor:m_forwardPathColor indoorId:step.indoorId floorId:step.indoorFloorId];
            }
            else
            {
                [self addLinesForRoutePath:forwardPath pathCount:forwardPathSize ofColor:m_forwardPathColor];
            }
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

-(void) updateRouteProgress:(int)sectionIndex
                  stepIndex:(int)stepIndex
         closestPointOnPath:(CLLocationCoordinate2D)closestPointOnPath
indexOfPathSegmentStartVertex:(int)indexOfPathSegmentStartVertex
{
    [self removeFromMap];
    
    NSMutableArray* sections = m_route.sections;
    for (int j=0; j<sections.count;j++)
    {
        WRLDRouteSection* section = [sections objectAtIndex:j];
        NSMutableArray* steps = section.steps;
        for (int i=0;i<steps.count;i++)
        {
            WRLDRouteStep* step = [steps objectAtIndex:i];
            if (step.pathCount < 2)
            {
                continue;
            }
            if (sectionIndex == j && stepIndex == i)
            {
                if (step.isMultiFloor)
                {
                    WRLDRouteStep* stepBefore = [steps objectAtIndex:i-1];
                    WRLDRouteStep* stepAfter = [steps objectAtIndex:i+1];
                    [self addLinesForFloorTransition:step stepBefore:stepBefore stepAfter:stepAfter];
                }
                else
                {
                    [self addLinesForRouteStep:step closestPointOnPath:closestPointOnPath splitIndex:indexOfPathSegmentStartVertex];
                }
            }
            else
            {
                [self addLinesForRouteStep:step];
            }
        }
    }
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

@end
