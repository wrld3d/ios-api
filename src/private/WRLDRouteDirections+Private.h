#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDRouteDirections;

@interface WRLDRouteDirections (Private)

- (instancetype)initWithType:(NSString*)type
                    modifier:(NSString*)modifier
                      latLng:(CLLocationCoordinate2D)latLng
               headingBefore:(CLLocationDirection)headingBefore
                headingAfter:(CLLocationDirection)headingAfter;

@end

NS_ASSUME_NONNULL_END
