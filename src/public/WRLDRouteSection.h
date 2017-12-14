#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A section of a WRLDRoute. For example, the portion from a point indoors to the exit.
 */
@interface WRLDRouteSection : NSObject

/*!
 @returns A List of the WRLDRouteStep objects that make up this section.
 */
- (NSMutableArray*) steps;

/*!
 @returns The estimated time this section will take to travel in seconds.
 */
- (NSTimeInterval) duration;

/*!
 @returns The estimated distance this section covers in meters.
 */
- (double) distance;

@end

NS_ASSUME_NONNULL_END
