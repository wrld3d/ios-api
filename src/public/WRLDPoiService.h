#pragma once

#import "WRLDPoiSearch.h"
#import "WRLDTextSearchOptions.h"
#import "WRLDTagSearchOptions.h"
#import "WRLDAutocompleteOptions.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 A service which allows you to search for POIs (Points Of Interest). Created by the createPoiService
 method of the WRLDMapView object.
 */
@interface WRLDPoiService : NSObject

/*!
 Begins a free-text search for POIs with the given query options. The results of the search will be
 passed as a WRLDPoiSearchResponse to the poiSearchDidComplete method on WRLDMapViewDelegate.

 @param options The text search options containing the query and other search criteria.
 @returns A handle to the ongoing search, which can be used to cancel it.
 */
- (WRLDPoiSearch*)searchText:(WRLDTextSearchOptions*)options;

/*!
 Begins a tag search for POIs with the given query options. The results of the search will be passed
 as a WRLDPoiSearchResponse to the poiSearchDidComplete method on WRLDMapViewDelegate.

 @param options The tag search options containing the query and other search criteria.
 @returns A handle to the ongoing search, which can be used to cancel it.
 */
- (WRLDPoiSearch*)searchTag:(WRLDTagSearchOptions*)options;

/*!
 Begins an autocomplete search for POIs with the given query options. The results of the search will
 be passed as a WRLDPoiSearchResponse to the poiSearchDidComplete method on WRLDMapViewDelegate.

 @param options The autocomplete search options containing the query and other search criteria.
 @returns A handle to the ongoing search, which can be used to cancel it.
 */
- (WRLDPoiSearch*)searchAutocomplete:(WRLDAutocompleteOptions*)options;

@end

NS_ASSUME_NONNULL_END
