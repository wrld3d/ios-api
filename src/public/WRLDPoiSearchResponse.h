#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A response to a POI search. Returned when a search completes via callback.
 */
@interface WRLDPoiSearchResponse : NSObject

/*!
 @returns A boolean indicating whether the search succeeded or not.
 */
@property (nonatomic) BOOL succeeded;

/*!
 Get the results of the search as a List of WRLDPoiSearchResult objects.
 @returns The search results. This will be empty if the the search failed, or if no POIs were found.
 */
@property (nonatomic) NSMutableArray* results;

@end

NS_ASSUME_NONNULL_END
