#pragma once

#include "EegeoMapApi.h"
#include "PositioningTypes.h"

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

const Eegeo::Positioning::ElevationMode::Type ToPositioningElevationMode(WRLDElevationMode elevationMode);

@end

NS_ASSUME_NONNULL_END
