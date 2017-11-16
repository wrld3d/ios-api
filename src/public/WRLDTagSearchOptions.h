#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A set of parameters for a tag search.
 */
@interface WRLDTagSearchOptions : NSObject

/*!
 @returns The tag to search for.
 */
- (NSString*)getQuery;

/*!
 Sets the tag to search for.
 @param query The tag to search for.
 */
- (void)setQuery:(NSString*)query;

/*!
 @returns The latitude and longitude to search around.
 */
- (CLLocationCoordinate2D)getCenter;

/*!
 Set the latitude and longitude to search around.
 @param center The latitude and longitude to search around.
 */
- (void)setCenter:(CLLocationCoordinate2D)center;

/*!
 @returns True if setRadius has been called.
 */
- (BOOL)usesRadius;

/*!
 @returns The search radius in meters.
 */
- (double)getRadius;

/*!
 @param radius Set the search radius in meters.
 */
- (void)setRadius:(double)radius;

/*!
 @returns True if setNumber has been called.
 */
- (BOOL)usesNumber;

/*!
 @returns The search result limit.
 */
- (NSInteger)getNumber;

/*!
 Sets the maximum number of search results to return.
 @param number The search result limit.
 */
- (void)setNumber:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END

