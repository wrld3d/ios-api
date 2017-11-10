#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDAutocompleteOptions : NSObject

// document me
- (NSString*)getQuery;

// document me
- (void)setQuery:(NSString*)query;

// document me
- (CLLocationCoordinate2D)getCenter;

// document me
- (void)setCenter:(CLLocationCoordinate2D)center;

// document me
- (BOOL)usesNumber;

// document me
- (NSInteger)getNumber;

// document me
- (void)setNumber:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END


