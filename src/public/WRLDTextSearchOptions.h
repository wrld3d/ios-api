#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A set of parameters for an free-text search.
 */
@interface WRLDTextSearchOptions : NSObject

/*!
 @returns The text to search for.
 */
- (NSString*)getQuery;

/*!
 Set the query text.
 @param query - The text to search for.
 */
- (void)setQuery:(NSString*)query;

/*!
 @returns The latitude and longitude to search around.
 */
- (CLLocationCoordinate2D)getCenter;

/*!
 Set the center coordinate.
 @param center - The latitude and longitude to search around.
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
 @param radius - Set the search radius in meters.
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
 @param number - The search result limit.
 */
- (void)setNumber:(NSInteger)number;

/*!
 @returns True if setMinScore has been called.
 */
- (BOOL)usesMinScore;

/*!
 @returns The minimum acceptable score for results.
 */
- (double)getMinScore;

/*!
 Sets the minimum score of results. The higher this is set, the fewer results will match.
 @param minScore - The minimum acceptable score for results.
 */
- (void)setMinScore:(double)minScore;

/*!
 @returns True if setIndoorMapId has been called.
 */
- (BOOL)usesIndoorMapId;

/*!
 @returns The indoor map ID to search in.
 */
- (NSString*)getIndoorMapId;

/*!
 Sets the ID of the indoor map to search in. If not specified, search outdoors.
 @param indoorMapId - The indoor map ID to search in.
 */
- (void)setIndoorMapId:(NSString*)indoorMapId;

/*!
 @returns True if setIndoorMapFloorId has been called.
 */
- (BOOL)usesIndoorMapFloorId;

/*!
 @returns The floor number to search on.
 */
- (NSInteger)getIndoorMapFloorId;

/*!
 Sets the floor number to search on. If searching indoors and not specified, defaults to floor 0.
 @param indoorMapFloorId - The floor number to search on.
 */
- (void)setIndoorMapFloorId:(NSInteger)indoorMapFloorId;

/*!
 @returns True if setFloorDropoff has been called.
 */
- (BOOL)usesFloorDropoff;

/*!
 @returns The number of floors above and below to search on.
 */
- (NSInteger)getFloorDropoff;

/*!
 Sets the floor dropoff. Defaults to 15.
 @param floorDropoff - The number of floors above and below to search on.
 */
- (void)setFloorDropoff:(NSInteger)floorDropoff;

@end

NS_ASSUME_NONNULL_END
