#pragma once

#include "EegeoMapApi.h"
#include "PoiSearchResults.h"
#include "PositioningTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (Private)
    
- (void)notifyMapViewRegionWillChange;
    
- (void)notifyMapViewRegionIsChanging;
    
- (void)notifyMapViewRegionDidChange;

- (void)notifyInitialStreamingCompleted;

- (void)notifyTouchTapped:(CGPoint)point;

- (void)notifyMarkerTapped:(int)markerId;

- (void)notifyPositionerProjectionChanged;

- (void)notifyEnteredIndoorMap;

- (void)notifyExitedIndoorMap;

- (void)notifyPoiSearchCompleted:(const Eegeo::PoiSearch::PoiSearchResults&)result;

- (Eegeo::Api::EegeoMapApi&)getMapApi;

const Eegeo::Positioning::ElevationMode::Type ToPositioningElevationMode(WRLDElevationMode elevationMode);

@end

NS_ASSUME_NONNULL_END
