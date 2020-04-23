#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDRouteStep;

@interface WRLDRouteStep (Private)

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
                    stepName:(NSString*)stepName;

@end

NS_ASSUME_NONNULL_END
