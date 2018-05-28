#pragma once

#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Defines creation parameters for a PointOnRoute.
 */
@interface WRLDPointOnRouteOptions : NSObject

/*!
 * Sets the indoor map ID to allow the point to test against routes indoors.
 *
 * @param indoorMapId The ID of the indoor map.
 * @return The WRLDPointOnRouteOptions object on which the method was called, with the new indoorMapId set.
 */
- (WRLDPointOnRouteOptions*) indoorMapId:(NSString*)indoorMapId;

/*!
 * Sets the indoor map floor ID to specify the floor and the point and route are on.
 *
 * @param indoorMapFloorId The floor ID  of the indoor map.
 * @return The PointOnRouteOptions object on which the method was called, with the new indoorMapFloorId set.
 */
- (WRLDPointOnRouteOptions*) indoorMapFloorId:(NSInteger)indoorMapFloorId;

- (NSString*) getIndoorMapId;

- (NSInteger) getIndoorMapFloorId;

@end

NS_ASSUME_NONNULL_END
