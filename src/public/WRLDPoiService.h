#pragma once

#import "WRLDPoiSearch.h"
#import "WRLDTextSearchOptions.h"
#import "WRLDTagSearchOptions.h"
#import "WRLDAutocompleteOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDPoiService : NSObject

/*
 do docs
 */
- (WRLDPoiSearch*)searchText:(WRLDTextSearchOptions*)options;

/*
 do more docs
 */
- (WRLDPoiSearch*)searchTag:(WRLDTagSearchOptions*)options;

/*
 docs
 */
- (WRLDPoiSearch*)searchAutocomplete:(WRLDAutocompleteOptions*)options;

@end

NS_ASSUME_NONNULL_END
