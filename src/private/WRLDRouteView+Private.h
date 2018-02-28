#pragma once

#include "WRLDMapView+Private.h"
#include "WRLDRoute+Private.h"
#include "WRLDRouteViewOptions.h"

//NS_ASSUME_NONNULL_BEGIN

@class WRLDRouteView;

@interface WRLDRouteView (Private)

- (instancetype)initWithMapView:(WRLDMapView*)map
                          route:(WRLDRoute*)route
                         option:(WRLDRouteViewOptions*)options;


@end

//NS_ASSUME_NONNULL_END
