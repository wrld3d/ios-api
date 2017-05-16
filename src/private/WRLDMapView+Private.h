#pragma once

#import <Foundation/Foundation.h>

#import "WRLDMapView.h"

#include "EegeoMapApi.h"


NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (Private)
    
- (void)notifyMapViewRegionWillChange;
    
- (void)notifyMapViewRegionIsChanging;
    
- (void)notifyMapViewRegionDidChange;

- (void)notifyInitialStreamingCompleted;

- (void)notifyMarkerTapped:(int)markerId;

- (void)notifyEnteredIndoorMap;

- (void)notifyExitedIndoorMap;

- (Eegeo::Api::EegeoMapApi&)getMapApi;

@end

NS_ASSUME_NONNULL_END
