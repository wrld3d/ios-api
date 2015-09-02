// Copyright (c) 2015 eeGeo. All rights reserved.

#pragma once

#import <Foundation/Foundation.h>
#import "EGPolygon.h"
#include "GeofenceModel.h"

@interface EGPolygonImplementation : NSObject<EGPolygon>
    @property (nonatomic, readwrite) Eegeo::Data::Geofencing::GeofenceModel* pGeofenceModel;
    - (instancetype)initWithGeofence:(Eegeo::Data::Geofencing::GeofenceModel&)geofence;
@end