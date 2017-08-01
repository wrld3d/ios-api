#include "EegeoSpacesApi.h"
#include "LatLongAltitude.h"
#include "WRLDIndoorGeoreferencer.h"
#include "WRLDMapView.h"
#include "WRLDMapView+Private.h"


@implementation WRLDIndoorGeoreferencer
{
    CLLocationCoordinate2D m_point1LatLong;
    float m_point1mapX;
    float m_point1mapY;
    CLLocationCoordinate2D m_point2LatLong;
    float m_point2mapX;
    float m_point2mapY;
    CLLocationCoordinate2D m_point3LatLong;
    float m_point3mapX;
    float m_point3mapY;
    WRLDMapView* m_pMapView;
}

- (instancetype)init: (CLLocationCoordinate2D) point1LatLong
          point1mapX: (float) point1mapX
          point1mapY: (float) point1mapY
       point2LatLong: (CLLocationCoordinate2D) point2LatLong
          point2mapX: (float) point2mapX
          point2mapY: (float) point2mapY
       point3LatLong: (CLLocationCoordinate2D) point3LatLong
          point3mapX: (float) point3mapX
          point3mapY: (float) point3mapY
             mapView: (WRLDMapView*) mapView
{
    m_point1LatLong = point1LatLong;
    m_point1mapX = point1mapX;
    m_point1mapY = point1mapY;
    m_point2LatLong = point2LatLong;
    m_point2mapX = point2mapX;
    m_point2mapY = point2mapY;
    m_point3LatLong = point3LatLong;
    m_point3mapX = point3mapX;
    m_point3mapY = point3mapY;
    m_pMapView = mapView;

    return self;
}

- (CLLocationCoordinate2D) mapPointToLatLong: (float) mapX
                                          mapY: (float) mapY
{
    Eegeo::Api::EegeoSpacesApi& spacesApi = [m_pMapView getMapApi].GetSpacesApi();
    Eegeo::Space::LatLong latLong = spacesApi.IndoorMapPointToLatLong(Eegeo::Space::LatLong::FromDegrees(m_point1LatLong.latitude, m_point1LatLong.longitude),
                                                               m_point1mapX,
                                                               m_point1mapY,
                                                               Eegeo::Space::LatLong::FromDegrees(m_point2LatLong.latitude, m_point2LatLong.longitude),
                                                               m_point2mapX,
                                                               m_point2mapY,
                                                               Eegeo::Space::LatLong::FromDegrees(m_point3LatLong.latitude, m_point3LatLong.longitude),
                                                               m_point3mapX,
                                                               m_point3mapY,
                                                               mapX,
                                                               mapY);

    return {latLong.GetLatitudeInDegrees(), latLong.GetLongitudeInDegrees()};
}

@end
