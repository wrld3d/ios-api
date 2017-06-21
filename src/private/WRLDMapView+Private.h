#pragma once

#include "EegeoMapApi.h"


NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (Private)
    
- (void)notifyMapViewRegionWillChange;
    
- (void)notifyMapViewRegionIsChanging;
    
- (void)notifyMapViewRegionDidChange;

- (void)notifyInitialStreamingCompleted;

- (void)notifyTouchTapped:(CGPoint)point;

- (void)notifyMarkerTapped:(int)markerId;

- (void)notifyEnteredIndoorMap;

- (void)notifyExitedIndoorMap;

- (Eegeo::Api::EegeoMapApi&)getMapApi;


- (nullable WRLDOverlayRenderer *) rendererForOverlay:(id <WRLDOverlay>)overlay;

@end

NS_ASSUME_NONNULL_END
