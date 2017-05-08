#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MarkerElevationMode)
{
    HeightAboveSeaLevel,
    HeightAboveGround
};

@interface WRLDMarker : NSObject

+ (instancetype)markerAtCoordinate:(CLLocationCoordinate2D)coordinate;

+ (instancetype)markerAtCoordinate:(CLLocationCoordinate2D)coordinate
                       inIndoorMap:(NSString *)indoorMapId
                           onFloor:(NSInteger)floorId;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) CLLocationDistance elevation;

@property (nonatomic) MarkerElevationMode elevationMode;

@property (nonatomic) NSInteger drawOrder;

@property (nonatomic, copy) NSString* title;

@property (nonatomic, readonly, copy) NSString* styleName;

@property (nonatomic, copy) NSString* userData;

@property (nonatomic, copy) NSString* iconKey;

@property (nonatomic, readonly, copy) NSString* indoorMapId;

@property (nonatomic, readonly) NSInteger indoorFloorId;

@end

NS_ASSUME_NONNULL_END
