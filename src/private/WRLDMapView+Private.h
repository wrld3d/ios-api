
#pragma once
#import <Foundation/Foundation.h>
#include "EegeoMapApi.h"


@class WRLDMapView;


NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (Private)

- (void)notifyInitialStreamingCompleted;

- (void)notifyMarkerTapped:(int)markerId;

- (void)notifyEnteredIndoorMap;

- (void)notifyExitedIndoorMap;

- (Eegeo::Api::EegeoMapApi&)getMapApi;

@end

NS_ASSUME_NONNULL_END
