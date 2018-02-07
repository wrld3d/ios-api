#pragma once

#import <Foundation/Foundation.h>

#import "WRLDTouchTapInfo.h"

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif
    WRLDTouchTapInfo WRLDTouchTapInfoMake(CGPoint screenPoint, WRLDCoordinateWithAltitude coordinateWithAltitude);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END

