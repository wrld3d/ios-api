#import "WRLDRouteView.h"
#import "WRLDRoute+Private.h"
#import "WRLDRouteViewOptions.h"
#import "WRLDRouteSection.h"
#import "WRLDRouteSection+Private.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "WRLDRouteViewHelper.h"
#include <vector>

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
                
                [self addLinesForFloorTransition:step stepBefore:stepBefore stepAfter:stepAfter isActiveStep:false];
            }
            else
            {
                [self addLinesForRouteStep:step];
            }
        }
    }
}

- (WRLDPolyline*) basePolyline:(CLLocationCoordinate2D *)coords
                         count:(NSUInteger)pathCount
                     routeStep:(WRLDRouteStep *)step                        
{
    WRLDPolyline* polyline = [WRLDPolyline polylineWithCoordinates:coords count:pathCount];
    polyline.color = m_color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    
    if(step.isIndoors)
    {
        [polyline setIndoorMapId:step.indoorId];
        [polyline setIndoorFloorId:step.indoorFloorId];
    }
    
    return polyline;
}

- (void) addLinesForRouteStep:(WRLDRouteStep*)step
{
     WRLDPolyline* polyline = [self basePolyline:step.path
                                           count:step.pathCount
                                       routeStep:step];
    
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
}

- (void) addLinesForFloorTransition:(WRLDRouteStep*)step
                         stepBefore:(WRLDRouteStep*)stepBefore
                          stepAfter:(WRLDRouteStep*)stepAfter
                       isActiveStep:(BOOL)isActiveStep
{
    NSInteger floorBefore = stepBefore.indoorFloorId;
    NSInteger floorAfter = stepAfter.indoorFloorId;
    CGFloat lineHeight = (floorAfter > floorBefore) ? (CGFloat)VERTICAL_LINE_HEIGHT : -(CGFloat)VERTICAL_LINE_HEIGHT;
    
    WRLDPolyline* polyline = [self makeVerticalLine:step floor:floorBefore height:lineHeight isActiveStep:isActiveStep];
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
    
    polyline = [self makeVerticalLine:step floor:floorAfter height:-lineHeight isActiveStep:isActiveStep];
    [m_polylines addObject:polyline];
    [m_map addOverlay:polyline];
}

- (WRLDPolyline*) makeVerticalLine:(WRLDRouteStep*)step
                             floor:(NSInteger)floor
                            height:(CGFloat)height
                      isActiveStep:(BOOL)isActiveStep
{
    WRLDPolyline* polyline = [self basePolyline:step.path
                                          count:step.pathCount
                                      routeStep:step];
    [polyline setIndoorFloorId:floor];
    if(isActiveStep)
    {
        polyline.color = m_forwardPathColor;
    }
    CGFloat elevations[2];
    elevations[0] = (CGFloat)0;
    elevations[1] = (CGFloat)height;
    [polyline setPerPointElevations:elevations count:2];
    return polyline;
}

-(void) updateRouteProgress:(int)sectionIndex
                  stepIndex:(int)stepIndex
        closestPointOnRoute:(CLLocationCoordinate2D)closestPointOnRoute
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
            
            BOOL isActiveStep = sectionIndex == j && stepIndex == i;
            
            if (step.isMultiFloor)
            {
                bool isValidTransition = i > 0 && i < (section.steps.count - 1) && step.isIndoors;
                
                if (!isValidTransition)
                {
                    continue;
                }
                
                WRLDRouteStep* stepBefore = [steps objectAtIndex:i-1];
                WRLDRouteStep* stepAfter = [steps objectAtIndex:i+1];
                [self addLinesForFloorTransition:step stepBefore:stepBefore stepAfter:stepAfter isActiveStep:isActiveStep];
            }
            else
            {
                if(isActiveStep)
                {
                    [self addLinesForRouteStep:step closestPointOnPath:closestPointOnRoute splitIndex:indexOfPathSegmentStartVertex];
                }
                else
                {
                    [self addLinesForRouteStep:step];
                }
            }
        }
    }
}

- (void) addLinesForRouteStep:(WRLDRouteStep*)step
           closestPointOnPath:(CLLocationCoordinate2D)closestPoint
                   splitIndex:(int)splitIndex
{
    std::vector<CLLocationCoordinate2D> backPath;
    backPath.reserve(splitIndex+2);
    for (int i=0; i<splitIndex+1; i++)
    {
        backPath.push_back(step.path[i]);
    }
    backPath.push_back(closestPoint);
    [self addLinesForActiveStepSegment:step pathSegment:backPath isForward:false];

    
    std::vector<CLLocationCoordinate2D> forwardPath;
    forwardPath.reserve(step.pathCount - splitIndex+2);
    forwardPath.push_back(closestPoint);
    for (int i=splitIndex+1; i<step.pathCount; i++)
    {
        forwardPath.push_back(step.path[i]);
    }
    [self addLinesForActiveStepSegment:step pathSegment:forwardPath isForward:true];
}

- (void) addLinesForActiveStepSegment:(WRLDRouteStep*)step
                          pathSegment:(const std::vector<CLLocationCoordinate2D> &)pathSegment
                            isForward:(BOOL)isForward {
    
    std::vector<CLLocationCoordinate2D> filteredPathSegment;
    [WRLDRouteViewHelper removeCoincidentPoints:pathSegment outPut:filteredPathSegment];
    
    if (filteredPathSegment.size() >= 2)
    {
        WRLDPolyline* polyline = [self basePolyline:filteredPathSegment.data()
                                              count:filteredPathSegment.size()
                                          routeStep:step];
        if(isForward)
        {
            polyline.color = m_forwardPathColor;
        }
        [m_polylines addObject:polyline];
        [m_map addOverlay:polyline];
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
