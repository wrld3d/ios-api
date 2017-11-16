#pragma once

#import <Foundation/Foundation.h>
#import "WRLDPoiSearchResponse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WRLDPoiSearchCompletedDelegate <NSObject>

@optional

/*!
 A message sent when a POI search completes.
 
 @param poiSearchId The ID of the WRLDPoiSearch.
 @param poiSearchResponse The POI search results.
 */
- (void)poiSearchDidComplete: (int) poiSearchId poiSearchResponse: (WRLDPoiSearchResponse*) poiSearchResponse;

@end

NS_ASSUME_NONNULL_END
