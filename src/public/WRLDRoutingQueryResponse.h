#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A response to a routing query.
 Returned when a routing query completes via routingQueryDidComplete method in WRLDMapViewDelegate.
 */
@interface WRLDRoutingQueryResponse : NSObject

/*!
 @returns A boolean indicating whether the search succeeded or not.
 */
- (BOOL) succeeded;

/*!
 Get the results of the query as a List of WRLDRoute objects.
 Each route passes through all given waypoints with the first route being the shortest.
 
 @return The query results.
 */
- (NSMutableArray*) results;

@end

NS_ASSUME_NONNULL_END
