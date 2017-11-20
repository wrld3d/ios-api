
#pragma once
#import <CoreLocation/CoreLocation.h>
#import "SearchResultProperty.h"


@interface SearchResult : NSObject

@property (nonatomic, copy) NSString* title;

@property (nonatomic, copy) NSString* subTitle;

@property (nonatomic, copy) NSString* iconKey;

@property (nonatomic) CLLocationCoordinate2D latLng;

- (SearchResultProperty*)getSearchProperty: (NSString*) propertyKey;

@end


