#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MarkerElevationMode)
{
    HeightAboveSeaLevel,
    HeightAboveGround
};

@interface WRLDMarkerOptions : NSObject

+ (instancetype)markerOptions;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) CLLocationDistance elevation;

@property (nonatomic) MarkerElevationMode elevationMode;

@property (nonatomic) NSInteger drawOrder;

@property (nonatomic) NSString* title;

@property (nonatomic) NSString* styleName;

@property (nonatomic) NSString* userData;

@property (nonatomic) NSString* iconKey;

@property (nonatomic, readonly) NSString* indoorMapId;

@property (nonatomic, readonly) NSInteger indoorFloorId;

- (void)setIndoorMapId:(NSString *)indoorMapId
            andFloorId:(NSInteger)floorId;

@end

NS_ASSUME_NONNULL_END
