#pragma once

#import "WRLDOverlay.h"

#include "EegeoApi.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WRLDOverlayType)
{
    WRLDOverlayMarker,
    
    WRLDOverlayPolygon,

    WRLDOverlayPolyline,

    WRLDOverlayPositioner,

    WRLDOverlayBuildingHighlight,

    WRLDOverlayIndoorMapInformation,
    
    WRLDOverlayProp
};

typedef struct _WRLDOverlayId
{
    WRLDOverlayType overlayType;
    int nativeHandle;
    
} WRLDOverlayId;

struct WRLDOverlayIdHash
{
    size_t operator() (const WRLDOverlayId& x) const
    {
        return x.overlayType ^ x.nativeHandle;
    }
};


struct WRLDOverlayIdEqual
{
    bool operator() (const WRLDOverlayId& a, const WRLDOverlayId& b) const
    {
        return a.overlayType == b.overlayType && a.nativeHandle == b.nativeHandle;
    }
};

@protocol WRLDOverlayImpl

- (void) createNative:(Eegeo::Api::EegeoMapApi&) mapApi;

- (void) destroyNative;

- (WRLDOverlayId) getOverlayId;


@end


NS_ASSUME_NONNULL_END
