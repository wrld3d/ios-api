// Copyright (c) 2015 eeGeo. All rights reserved.

#import "EGPolygonImplementation.h"
#include <vector>

@implementation EGPolygonImplementation
{

}

- (instancetype)initWithGeofence:(Eegeo::Data::Geofencing::GeofenceModel&)geofence
{
    self = [super init];

    if (self)
    {
        self.pGeofenceModel = &geofence;
    }

    return self;
}

- (void)setColor:(float)r g:(float)g b:(float)b a:(float)a
{
    Eegeo::v4 colour(r, g, b, a);
    self.pGeofenceModel->SetPolygonColor(colour);
}

@end