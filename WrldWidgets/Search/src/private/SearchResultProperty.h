#pragma once

@interface SearchResultProperty <__covariant T> : NSObject

- (NSString*)getKey;

- (T)getValue;

- (int)compareTo: (SearchResultProperty<T>*) compareProperty;

@end

