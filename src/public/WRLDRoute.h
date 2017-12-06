#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 An object representing a route on the map.
 */
@interface WRLDRoute : NSObject

/*!
 A List of the different WRLDRouteSection objects which make up this route.
 */
@property (nonatomic) NSMutableArray* sections;

/*!
 The estimated time this route will take to travel in seconds.
 */
@property (nonatomic) double duration;

/*!
 The estimated distance this route covers in meters.
 */
@property (nonatomic) double distance;

@end

NS_ASSUME_NONNULL_END
