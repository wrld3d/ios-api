#import "WRLDTouchTapInfo.h"
#import "WRLDTouchTapInfo+Private.h"

WRLDTouchTapInfo WRLDTouchTapInfoMake(CGPoint screenPoint, WRLDCoordinateWithAltitude coordinateWithAltitude)
{
    WRLDTouchTapInfo tapInfo;
    tapInfo.screenPoint = screenPoint;
    tapInfo.coordinateWithAltitude = coordinateWithAltitude;
    return tapInfo;
}
