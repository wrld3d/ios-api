
#pragma once

#import "SearchResultProperty.h"

@interface SearchResult : NSObject

@property (nonatomic, copy) NSString* title;

- (SearchResultProperty*)getSearchProperty: (NSString*) propertyKey;

@end


