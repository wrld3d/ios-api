// Copyright (c) 2015 eeGeo. All rights reserved.

#import "EGPolygonImplementation.h"
#include <vector>
#include <unordered_set>

// :TODO: reconsider this approach - will be hard to maintain if we expose stuff to the iOS API
@implementation EGPolygonImplementation
{
    bool m_isInScene;
    Eegeo::v4 m_color;
    Eegeo::Api::TGeofenceId m_id;
    Eegeo::Api::EegeoGeofenceApi* m_pApi;
    std::vector<Eegeo::Space::LatLongAltitude> m_verts;
}

namespace
{
    static Eegeo::Api::TGeofenceId s_geofenceIdGenerator = 0;
    static std::unordered_set<Eegeo::Api::TGeofenceId> s_usedIds;

    static Eegeo::Api::TGeofenceId GenerateNewId()
    {
        Eegeo::Api::TGeofenceId result;
        
        do
        {
            result = s_geofenceIdGenerator++;
        }
        while (s_usedIds.find(result) != s_usedIds.end());
        
        return result;
    }
}

- (instancetype)initWithVerts:(const std::vector<Eegeo::Space::LatLongAltitude>&)verts
                          api:(Eegeo::Api::EegeoGeofenceApi&)api
                        color:(const Eegeo::v4&)color;
{
    self = [super init];

    if (self)
    {
        m_isInScene = false;
        m_verts = verts;
        m_pApi = &api;
        m_color = color;
    }

    return self;
}

- (void)setColor:(float)r g:(float)g b:(float)b a:(float)a
{
    m_color = Eegeo::v4(r, g, b, a);
    
    if (m_isInScene)
    {
        [self applyColor];
    }
}

- (void) applyColor
{
    Eegeo::Data::Geofencing::GeofenceModel& model = m_pApi->GetGeofence(m_id);
    model.SetPolygonColor(m_color);
}

- (void)addToScene
{
    if (m_isInScene)
    {
        return;
    }
    
    Eegeo::Api::TGeofenceId geofenceId = GenerateNewId();
    m_pApi->CreateGeofence(geofenceId, self->m_verts);
    m_isInScene = true;
    
    [self applyColor];
}

- (void)removeFromScene
{
    m_isInScene = false;
    s_usedIds.erase(m_id);
    m_id = -1;
}

@end