#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Directions information for a WRLDRouteStep of a WRLDRoute.
 */
@interface WRLDRouteDirections : NSObject

/*!
 @returns The type of motion to make at this step. For example, "turn".
 */
 - (NSString*) type;

/*!
 @returns A modification to the type. For example, "sharp right".
 */
- (NSString*) modifier;

/*!
 @returns The geographic location this direction applies at.
 */
- (CLLocationCoordinate2D) latLng;

/*!
 @returns The heading before taking this direction.
 */
- (CLLocationDirection) headingBefore;

/*!
 @returns The heading after taking this direction.
 */
- (CLLocationDirection) headingAfter;

@end

NS_ASSUME_NONNULL_END
