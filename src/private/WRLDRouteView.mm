#import <CoreLocation/CoreLocation.h>

#import "WRLDRouteView.h"
#import "WRLDRoute+Private.h"
#import "WRLDRouteViewOptions.h"
#import "WRLDRouteSection.h"
#import "WRLDRouteSection+Private.h"
#import "WRLDRouteViewHelper.h"
#import "WRLDRouteViewAmalgamationHelper.h"
#import "WRLDRoutingPolylineCreateParams.h"

#include <vector>
#include <map>

@interface WRLDRouteView ()

@end

@implementation WRLDRouteView
{
    WRLDMapView* m_map;
    WRLDRoute* m_route;
    NSMutableArray* m_polylinesForward;
    NSMutableArray* m_polylinesBackward;
    BOOL m_currentlyOnMap;
    CGFloat m_width;
    UIColor* m_color;
    UIColor* m_forwardPathColor;
    CGFloat m_miterLimit;
    
    std::map<int, WRLDRoutingPolylineCreateParamsVector> m_routeStepToPolylineCreateParams;
}

- (instancetype)initWithMapView:(WRLDMapView*)map
                          route:(WRLDRoute*)route
                        options:(WRLDRouteViewOptions*)options
{
    if (self = [super init])
    {
        m_polylinesForward = [[NSMutableArray alloc] init];
        m_polylinesBackward = [[NSMutableArray alloc] init];
        
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
    int flattenedStepIndex=0;
    for (WRLDRouteSection* section in m_route.sections)
    {
        for(int i=0; i< section.steps.count; i++)
        {
            WRLDRouteStep* step = [section.steps objectAtIndex:i];
            
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
                
                [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenedStepIndex:flattenedStepIndex isForwardColor:false];
            }
            else
            {
                [self addLineCreationParamsForStep:step flattenedStepIndex:flattenedStepIndex];
            }
            
            flattenedStepIndex++;
        }
    }
    [self refreshPolylines];
}

- (void) updateRouteProgress:(int)sectionIndex
                   stepIndex:(int)stepIndex
         closestPointOnRoute:(CLLocationCoordinate2D)closestPointOnRoute
indexOfPathSegmentStartVertex:(int)indexOfPathSegmentStartVertex
{
    [self removeFromMap];
    
    NSMutableArray* sections = m_route.sections;
    int flattenedStepIndex = 0;
    
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
                
                if (isActiveStep)
                {
                    bool hasReachedEnd = indexOfPathSegmentStartVertex == (step.pathCount-1);
                    
                    [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenedStepIndex:flattenedStepIndex isForwardColor:!hasReachedEnd];

                }
                else
                {
                    [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenedStepIndex:flattenedStepIndex isForwardColor:false];
                }
            }
            else
            {
                if (isActiveStep)
                {
                    [self addLineCreationParamsForStep:step stepIndex:flattenedStepIndex closestPointOnPath:closestPointOnRoute splitIndex:indexOfPathSegmentStartVertex];
                }
                else
                {
                    [self addLineCreationParamsForStep:step flattenedStepIndex:flattenedStepIndex];
                    
                }
            }
            flattenedStepIndex ++;
        }
    }
    [self refreshPolylines];
}

- (void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep
                           stepBefore:(WRLDRouteStep*)routeStepBefore
                            stepAfter:(WRLDRouteStep*)routeStepAfter
                   flattenedStepIndex:(int)flattenedStepIndex
                       isForwardColor:(bool)isForwardColor
{
    if (routeStep.pathCount < 2)
    {
        return;
    }
    
    m_routeStepToPolylineCreateParams[flattenedStepIndex] = [WRLDRouteViewHelper CreateLinesForFloorTransition:routeStep
                                                                                                 floorBefore:routeStepBefore.indoorFloorId
                                                                                                  floorAfter:routeStepAfter.indoorFloorId
                                                                                                isForwardColor:isForwardColor];
}

- (void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep flattenedStepIndex:(int)flattenedStepIndex
{
    if (routeStep.pathCount < 2)
    {
        return;
    }
    
    m_routeStepToPolylineCreateParams[flattenedStepIndex] = [WRLDRouteViewHelper CreateLinesForRouteDirection:routeStep isForwardColor:false];
}

- (void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep
                            stepIndex:(int)stepIndex
                   closestPointOnPath:(CLLocationCoordinate2D)closestPointOnPath
                           splitIndex:(int)splitIndex
{
    if (routeStep.pathCount < 2)
    {
        return;
    }

    m_routeStepToPolylineCreateParams[stepIndex] = [WRLDRouteViewHelper CreateLinesForRouteDirection:routeStep splitIndex:splitIndex closestPointOnPath:closestPointOnPath];
}

- (void) refreshPolylines
{
    [self removeFromMap];
    
    Eegeo_ASSERT(m_polylinesForward.count == 0);

    WRLDRoutingPolylineCreateParamsVector allPolylineCreateParams;
    
    for (const auto& pair : m_routeStepToPolylineCreateParams)
    {
        const auto& createParams = pair.second;
        allPolylineCreateParams.insert(allPolylineCreateParams.end(), createParams.begin(), createParams.end());
    }
    
    [WRLDRouteViewAmalgamationHelper CreatePolylines:allPolylineCreateParams width:m_width miterLimit:m_miterLimit outBackwardPolylines:m_polylinesBackward outForwardPolylines:m_polylinesForward];
    
    for (WRLDPolyline* polyline in m_polylinesBackward)
    {
        polyline.color = m_color;
        [m_map addOverlay:polyline];
    }
    
    for (WRLDPolyline* polyline in m_polylinesForward)
    {
        polyline.color = m_forwardPathColor;
        [m_map addOverlay:polyline];
    }
}

- (void) removeFromMap
{
    for (WRLDPolyline* poly in m_polylinesBackward)
    {
        [m_map removeOverlay:poly];
    }
    [m_polylinesBackward removeAllObjects];
    
    for (WRLDPolyline* poly in m_polylinesForward)
    {
        [m_map removeOverlay:poly];
    }
    [m_polylinesForward removeAllObjects];
}

- (void) setWidth:(CGFloat)width
{
    m_width = width;
    for (WRLDPolyline* polyline in m_polylinesBackward)
    {
        [polyline setLineWidth:m_width];
    }
    
    for (WRLDPolyline* polyline in m_polylinesForward)
    {
        [polyline setLineWidth:m_width];
    }
}

- (void) setColor:(UIColor*)color
{
    m_color = color;
    for (WRLDPolyline* polyline in m_polylinesBackward)
    {
        [polyline setColor:m_color];
    }
}

- (void) setForwardColor:(UIColor *)color
{
    m_forwardPathColor = color;
    for (WRLDPolyline* polyline in m_polylinesForward)
    {
        [polyline setColor:m_forwardPathColor];
    }
}


- (void) setMiterLimit:(CGFloat)miterLimit
{
    m_miterLimit = miterLimit;
    for (WRLDPolyline* polyline in m_polylinesBackward)
    {
        [polyline setMiterLimit:m_miterLimit];
    }
    
    for (WRLDPolyline* polyline in m_polylinesForward)
    {
        [polyline setMiterLimit:m_miterLimit];
    }
}

- (void) addLinesForRouteStep:(WRLDRouteStep*)step
{
    int currentStepToPolylineCreateParamsSize = (int)m_routeStepToPolylineCreateParams.size();
    [self addLineCreationParamsForStep:step flattenedStepIndex:currentStepToPolylineCreateParamsSize];
    
    [self refreshPolylines];
}

- (void) addLinesForFloorTransition:(WRLDRouteStep*)step
                         stepBefore:(WRLDRouteStep*)stepBefore
                          stepAfter:(WRLDRouteStep*)stepAfter
{
    int currentStepToPolylineCreateParamsSize = (int)m_routeStepToPolylineCreateParams.size();
    
    [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenedStepIndex:currentStepToPolylineCreateParamsSize isForwardColor:false];
    
    [self refreshPolylines];
}

- (WRLDPolyline*) makeVerticalLine:(WRLDRouteStep*)step
                             floor:(NSInteger)floor
                            height:(CGFloat)height
{
    WRLDPolyline* polyline = [WRLDPolyline polylineWithCoordinates:step.path count:step.pathCount];
    polyline.color = m_color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    
    if (step.isIndoors)
    {
        [polyline setIndoorMapId:step.indoorId];
        [polyline setIndoorFloorId:step.indoorFloorId];
    }

    [polyline setIndoorFloorId:floor];
    
    CGFloat elevations[2];
    elevations[0] = (CGFloat)0;
    elevations[1] = (CGFloat)height;
    [polyline setPerPointElevations:elevations count:2];
    return polyline;
}

@end
