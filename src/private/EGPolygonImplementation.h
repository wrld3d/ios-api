// Copyright (c) 2015 eeGeo. All rights reserved.

#pragma once

#import <Foundation/Foundation.h>
#import "EGPolygon.h"
#include "GeofenceModel.h"
#include "EegeoGeofenceApi.h"
#include <vector>

@interface EGPolygonImplementation : NSObject<EGPolygon>
    - (instancetype)initWithVerts:(const std::vector<Eegeo::Space::LatLongAltitude>&)verts
                              api:(Eegeo::Api::EegeoGeofenceApi&)api
                            color:(const Eegeo::v4&)color;
    - (void) addToScene;
    - (void) removeFromScene;
@end