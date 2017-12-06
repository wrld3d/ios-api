#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Directions information for a WRLDRouteStep of a WRLDRoute.
 */
@interface WRLDRouteDirections : NSObject

/*!
 The type of motion to make at this step. For example, "turn".
 */
 @property (nonatomic, copy) NSString* type;

/*!
 A modification to the type. For example, "sharp right".
 */
@property (nonatomic, copy) NSString* modifier;

/*!
 The geographic location this direction applies at.
 */
@property (nonatomic) CLLocationCoordinate2D latLng;

/*!
 The heading before taking this direction.
 */
@property (nonatomic) CLLocationDirection headingBefore;

/*!
 The heading after taking this direction.
 */
@property (nonatomic) CLLocationDirection headingAfter;

@end

NS_ASSUME_NONNULL_END
