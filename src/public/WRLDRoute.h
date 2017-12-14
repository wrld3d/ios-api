#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 An object representing a route on the map.
 */
@interface WRLDRoute : NSObject

/*!
 @returns A List of the different WRLDRouteSection objects which make up this route.
 */
- (NSMutableArray*) sections;

/*!
 @returns The estimated time this route will take to travel in seconds.
 */
- (NSTimeInterval) duration;

/*!
 @returns The estimated distance this route covers in meters.
 */
- (double) distance;

@end

NS_ASSUME_NONNULL_END
