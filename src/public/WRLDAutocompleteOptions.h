#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A set of parameters for an autocomplete search.
 */
@interface WRLDAutocompleteOptions : NSObject

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
 @returns True if setNumber has been called.
 */
- (BOOL)usesNumber;

/*!
 @returns The search result limit.
 */
- (NSInteger)getNumber;

/*!
 Sets the maximum number of search results to return.
 @param The search result limit.
 */
- (void)setNumber:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END


