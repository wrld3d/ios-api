#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDSearchProvider.h"

/// The type of a search result
typedef enum WRLDSearchResultType : NSUInteger {
    WRLDResult,
    WRLDSuggestion
} WRLDSearchResultType;

/// Describes a single search result
@interface WRLDSearchResult : NSObject

/// The search provider that generated this result
@property (nonatomic) id<WRLDSearchProvider> searchProvider;

/// The type of search performed, either suggestions or normal search
@property (nonatomic) WRLDSearchResultType type;

/// The title of this result
@property (nonatomic, copy) NSString* title;

/// A sub title to be displayed under the main title in a smaller font
@property (nonatomic, copy) NSString* subTitle;

/// The icon to display on search result
@property (nonatomic, copy) NSString* iconKey;

/// Search tags associated with the result
@property (nonatomic, copy) NSString* tags;

/// The coordinate of this result
@property (nonatomic) CLLocationCoordinate2D latLng;

@end


