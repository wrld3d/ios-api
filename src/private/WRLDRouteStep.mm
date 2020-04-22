#import "WRLDRouteStep.h"
#import "WRLDRouteStep+Private.h"

@interface WRLDRouteStep ()

@end

@implementation WRLDRouteStep
{
    CLLocationCoordinate2D* m_path;
    int m_pathCount;
    WRLDRouteDirections* m_directions;
    WRLDRouteTransportationMode m_mode;
    BOOL m_isIndoors;
    NSString* m_indoorId;
    int m_indoorFloorId;
    BOOL m_isMultiFloor;
    NSTimeInterval m_duration;
    CLLocationDistance m_distance;
    NSString* m_stepName;
}

- (instancetype)initWithPath:(CLLocationCoordinate2D*)path
                   pathCount:(int)pathCount
                  directions:(WRLDRouteDirections*)directions
                        mode:(WRLDRouteTransportationMode)mode
                   isIndoors:(BOOL)isIndoors
                    indoorId:(NSString*)indoorId
                isMultiFloor:(BOOL)isMultiFloor
               indoorFloorId:(int)indoorFloorId
                    duration:(NSTimeInterval)duration
                    distance:(CLLocationDistance)distance
                    stepName:(NSString*)stepName
{
    if (self = [super init])
    {
        m_path = path;
        m_pathCount = pathCount;
        m_directions = directions;
        m_mode = mode;
        m_isIndoors = isIndoors;
        m_indoorId = indoorId;
        m_isMultiFloor = isMultiFloor;
        m_indoorFloorId = indoorFloorId;
        m_duration = duration;
        m_distance = distance;
        m_stepName = stepName;
    }

    return self;
}

- (CLLocationCoordinate2D*) path
{
    return m_path;
}

- (int) pathCount
{
    return m_pathCount;
}

- (WRLDRouteDirections*) directions
{
    return m_directions;
}

- (WRLDRouteTransportationMode) mode
{
    return m_mode;
}

- (BOOL) isIndoors
{
    return m_isIndoors;
}

- (NSString*) indoorId
{
    return m_indoorId;
}

- (BOOL) isMultiFloor
{
    return m_isMultiFloor;
}

- (int) indoorFloorId
{
    return m_indoorFloorId;
}

- (NSTimeInterval) duration
{
    return m_duration;
}

- (CLLocationDistance) distance
{
    return m_distance;
}

- (NSString*) stepName
{
    return m_stepName;
}

@end
