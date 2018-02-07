#pragma once

#import <CoreGraphics/CoreGraphics.h>

#import "WRLDCoordinateWithAltitude.h"

struct WRLDTouchTapInfo {
    CGPoint screenPoint;
    WRLDCoordinateWithAltitude coordinateWithAltitude;
};
typedef struct WRLDTouchTapInfo WRLDTouchTapInfo;
