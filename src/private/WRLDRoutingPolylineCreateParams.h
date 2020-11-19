#pragma once

#include "VectorMath.h"
#include "LatLongAltitude.h"

#include <string>

class WRLDRoutingPolylineCreateParams
{
public:
    WRLDRoutingPolylineCreateParams(
        const std::vector<CLLocationCoordinate2D>& coordinates,
        UIColor* color,
        NSString* indoorMapId,
        int indoorMapFloorId,
        const std::vector<CGFloat>& perPointElevations
    )
    : m_coordinates(coordinates)
    , m_color(color)
    , m_indoorMapId(indoorMapId)
    , m_indoorMapFloorId(indoorMapFloorId)
    , m_perPointElevations(perPointElevations)
    {
    }

    const std::vector<CLLocationCoordinate2D>& GetCoordinates() const { return m_coordinates; }
    UIColor* GetColor() const { return m_color; }
    NSString* GetIndoorMapId() const { return m_indoorMapId; }
    int GetIndoorMapFloorId() const { return m_indoorMapFloorId; }
    const std::vector<CGFloat>& GetPerPointElevations() const { return m_perPointElevations; }
    bool IsIndoor() const { return ![m_indoorMapId isEqualToString:@""]; }

private:
    std::vector<CLLocationCoordinate2D> m_coordinates;
    UIColor* m_color;
    NSString* m_indoorMapId;
    int m_indoorMapFloorId;
    std::vector<CGFloat> m_perPointElevations;
};
