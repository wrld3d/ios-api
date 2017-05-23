#pragma once

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

struct WRLDCoordinateWithAltitude {
    CLLocationCoordinate2D coordinate;
    CLLocationDistance altitude;
};
typedef struct WRLDCoordinateWithAltitude WRLDCoordinateWithAltitude;

#ifdef __cplusplus
extern "C" {
#endif
WRLDCoordinateWithAltitude WRLDCoordinateWithAltitudeMake(CLLocationCoordinate2D coordinate, CLLocationDistance altitude);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
