#import "WRLDRouteView.h"
#import "WRLDRoute+Private.h"
#import "WRLDRouteViewOptions.h"
#import "WRLDRouteSection.h"
#import "WRLDRouteSection+Private.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "WRLDRouteViewHelper.h"
#import "WRLDRouteViewAmalgamationHelper.h"
#include <vector>
#include <map>

#import "WRLDRoutingPolylineCreateParams.h"

@interface WRLDRouteView ()

@end

@implementation WRLDRouteView
{
    WRLDMapView* m_map;
    WRLDRoute* m_route;
    NSMutableArray* m_polylineIds;
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
        m_polylineIds = [[NSMutableArray alloc] init];
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
    int flattenStepIndex=0;
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
                
                [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenStepIndex:flattenStepIndex color:m_color];
            }
            else
            {
                [self addLineCreationParamsForStep:step ndFlattenStepIndex:flattenStepIndex];
            }
            
            flattenStepIndex++;
        }
    }
    [self refreshPolylines];
}

-(void) updateRouteProgress:(int)sectionIndex
                  stepIndex:(int)stepIndex
        closestPointOnRoute:(CLLocationCoordinate2D)closestPointOnRoute
indexOfPathSegmentStartVertex:(int)indexOfPathSegmentStartVertex
{
    [self removeFromMap];
    
    NSMutableArray* sections = m_route.sections;
    int flattenStepIndex = 0;
    
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
                
                if(isActiveStep) {
                    bool hasReachedEnd = indexOfPathSegmentStartVertex == (step.pathCount-1);
                    
                    [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenStepIndex:flattenStepIndex color:(hasReachedEnd ? m_color : m_forwardPathColor)];

                } else {
                    [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenStepIndex:flattenStepIndex color:m_color];
                }
            }
            else
            {
                if(isActiveStep)
                {
                    [self addLineCreationParamsForStep:step stepIndex:flattenStepIndex closestPointOnPath:closestPointOnRoute splitIndex:indexOfPathSegmentStartVertex];
                }
                else
                {
                    [self addLineCreationParamsForStep:step ndFlattenStepIndex:flattenStepIndex];
                    
                }
            }
            flattenStepIndex ++;
        }
    }
    [self refreshPolylines];
}

-(void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep
                          stepBefore:(WRLDRouteStep*)routeStepBefore
                           stepAfter:(WRLDRouteStep*)routeStepAfter
                    flattenStepIndex:(int)flattenStepIndex
                               color:(UIColor *)color
{
    if (routeStep.pathCount < 2)
    {
        return;
    }
    
    m_routeStepToPolylineCreateParams[flattenStepIndex] = [WRLDRouteViewHelper CreateLinesForFloorTransition:routeStep
                                                                                                 floorBefore:routeStepBefore.indoorFloorId
                                                                                                  floorAfter:routeStepAfter.indoorFloorId
                                                                                                     color:color];
}

-(void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep ndFlattenStepIndex:(int)flattenStepIndex
{
    if (routeStep.pathCount < 2)
    {
        return;
    }
    
    m_routeStepToPolylineCreateParams[flattenStepIndex] = [WRLDRouteViewHelper CreateLinesForRouteDirection:routeStep color:m_color];
}

-(void) addLineCreationParamsForStep:(WRLDRouteStep*)routeStep
                           stepIndex:(int)stepIndex
                  closestPointOnPath:(CLLocationCoordinate2D)closestPointOnPath
                        splitIndex:(int)splitIndex
{
    if (routeStep.pathCount < 2)
    {
        return;
    }

    m_routeStepToPolylineCreateParams[stepIndex] = [WRLDRouteViewHelper CreateLinesForRouteDirection:routeStep forwardColor:m_forwardPathColor backwardColor:m_color splitIndex:splitIndex closestPointOnPath:closestPointOnPath];
}

-(void) refreshPolylines
{
    [self removeFromMap];
    
    Eegeo_ASSERT(m_polylineIds.count == 0);

    WRLDRoutingPolylineCreateParamsVector allPolylineCreateParams;
    
    for (const auto& pair : m_routeStepToPolylineCreateParams)
    {
        const auto& createParams = pair.second;
        allPolylineCreateParams.insert(allPolylineCreateParams.end(), createParams.begin(), createParams.end());
    }
    
    m_polylineIds = [WRLDRouteViewAmalgamationHelper CreatePolylines:allPolylineCreateParams width:m_width miterLimit:m_miterLimit];
    
    for(WRLDPolyline* polyline in m_polylineIds) {
        [m_map addOverlay:polyline];
    }
}

- (void) removeFromMap
{
    for(WRLDPolyline* poly in m_polylineIds)
    {
        [m_map removeOverlay:poly];
    }
    [m_polylineIds removeAllObjects];
}

- (void) setWidth:(CGFloat)width
{
    m_width = width;
    for(WRLDPolyline* polyline in m_polylineIds)
    {
        [polyline setLineWidth:m_width];
    }
}

- (void) setColor:(UIColor*)color
{
    m_color = color;
    for(WRLDPolyline* polyline in m_polylineIds)
    {
        [polyline setColor:m_color];
    }
}

- (void) setMiterLimit:(CGFloat)miterLimit
{
    m_miterLimit = miterLimit;
    for(WRLDPolyline* polyline in m_polylineIds)
    {
        [polyline setMiterLimit:m_miterLimit];
    }
}

- (void) addLinesForRouteStep:(WRLDRouteStep*)step
{
    int currentStepToPolylineCreateParamsSize = (int)m_routeStepToPolylineCreateParams.size();
    [self addLineCreationParamsForStep:step ndFlattenStepIndex:currentStepToPolylineCreateParamsSize];
    
    [self refreshPolylines];
}

- (void) addLinesForFloorTransition:(WRLDRouteStep*)step
                         stepBefore:(WRLDRouteStep*)stepBefore
                          stepAfter:(WRLDRouteStep*)stepAfter
                       isActiveStep:(BOOL)isActiveStep
{
    int currentStepToPolylineCreateParamsSize = (int)m_routeStepToPolylineCreateParams.size();
    UIColor *routeColor = isActiveStep ? m_forwardPathColor : m_color;
    
    [self addLineCreationParamsForStep:step stepBefore:stepBefore stepAfter:stepAfter flattenStepIndex:currentStepToPolylineCreateParamsSize color:routeColor];
    
    [self refreshPolylines];
}

- (WRLDPolyline*) makeVerticalLine:(WRLDRouteStep*)step
                             floor:(NSInteger)floor
                            height:(CGFloat)height
                      isActiveStep:(BOOL)isActiveStep
{
    WRLDPolyline* polyline = [WRLDPolyline polylineWithCoordinates:step.path count:step.pathCount];
    polyline.color = m_color;
    polyline.lineWidth = m_width;
    polyline.miterLimit = m_miterLimit;
    
    if(step.isIndoors)
    {
        [polyline setIndoorMapId:step.indoorId];
        [polyline setIndoorFloorId:step.indoorFloorId];
    }

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

@end
