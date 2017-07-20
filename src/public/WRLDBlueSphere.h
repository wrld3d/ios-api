#pragma once

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "WRLDElevationMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDBlueSphere : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) CLLocationDirection heading;

@property (nonatomic, readonly, copy) NSString* indoorMapId;

@property (nonatomic) NSInteger indoorFloorId;


@property (nonatomic) CLLocationDistance elevation;

@property (nonatomic) bool enabled;

@property (nonatomic) WRLDElevationMode elevationMode;

- (void)setIndoorMap:(NSString * _Nonnull)indoorMapId
withIndoorMapFloorId:(NSInteger)indoorMapFloorId;



@end

NS_ASSUME_NONNULL_END
