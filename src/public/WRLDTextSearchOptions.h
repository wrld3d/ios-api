#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDTextSearchOptions : NSObject


// document me
- (NSString*)getQuery;

// document me
- (void)setQuery:(NSString*)query;

// document me
- (CLLocationCoordinate2D)getCenter;

// document me
- (void)setCenter:(CLLocationCoordinate2D)center;

// document me -- remember to set useRadius in setRadius()
- (BOOL)usesRadius;

// document me
- (double)getRadius;

// document me
- (void)setRadius:(double)radius;

// document me
- (BOOL)usesNumber;

// document me
- (NSInteger)getNumber;

// document me
- (void)setNumber:(NSInteger)number;

// document me
- (BOOL)usesMinScore;

// document me
- (double)getMinScore;

// document me
- (void)setMinScore:(double)minScore;

// document me
- (BOOL)usesIndoorMapId;

// document me
- (NSString*)getIndoorMapId;

// document me
- (void)setIndoorMapId:(NSString*)indoorMapId;

// document me
- (BOOL)usesIndoorMapFloorId;

// document me
- (NSInteger)getIndoorMapFloorId;

// document me
- (void)setIndoorMapFloorId:(NSInteger)indoorMapFloorId;

// document me
- (BOOL)usesFloorDropoff;

// document me
- (NSInteger)getFloorDropoff;

// document me
- (void)setFloorDropoff:(NSInteger)floorDropoff;

@end

NS_ASSUME_NONNULL_END
