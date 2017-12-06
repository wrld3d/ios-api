#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A section of a WRLDRoute. For example, the portion from a point indoors to the exit.
 */
@interface WRLDRouteSection : NSObject

/*!
 A List of the WRLDRouteStep objects that make up this section.
 */
@property (nonatomic) NSMutableArray* steps;

/*!
 The estimated time this section will take to travel in seconds.
 */
@property (nonatomic) double duration;

/*!
 The estimated distance this section covers in meters.
 */
@property (nonatomic) double distance;

@end

NS_ASSUME_NONNULL_END
