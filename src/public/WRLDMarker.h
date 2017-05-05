#pragma once

#import "WRLDMarkerOptions.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDMapView;

@interface WRLDMarker : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) CLLocationDistance elevation;

@property (nonatomic) MarkerElevationMode elevationMode;

@property (nonatomic) NSInteger drawOrder;

@property (nonatomic) NSString* title;

@property (nonatomic, readonly) NSString* styleName;

@property (nonatomic) NSString* userData;

@property (nonatomic) NSString* iconKey;

@end

NS_ASSUME_NONNULL_END
