#pragma once

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "WRLDElevationMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDBlueSphere : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) CLLocationDirection direction;

@property (nonatomic, readonly, copy) NSString* indoorMapId;

@property (nonatomic) NSInteger indoorFloorId;

@property (nonatomic) CLLocationDistance elevation;

@property (nonatomic) bool enabled;

- (void)setIndoorMap:(NSString * _Nonnull)indoorMapId
withIndoorMapFloorId:(NSInteger)indoorMapFloorId;

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
            direction:(CLLocationDirection) direction;


@end

NS_ASSUME_NONNULL_END
