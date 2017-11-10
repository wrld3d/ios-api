#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDPoiSearchResult : NSObject

@property (nonatomic) int id;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* subtitle;
@property (nonatomic) NSString* tags;
@property (nonatomic) CLLocationCoordinate2D latLng;
@property (nonatomic) double heightOffset;
@property (nonatomic) BOOL indoor;
@property (nonatomic) NSString* indoorMapId;
@property (nonatomic) int indoorMapFloorId;
@property (nonatomic) NSString* userData;

@end

NS_ASSUME_NONNULL_END
