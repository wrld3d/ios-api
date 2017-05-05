
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"
#import "WRLDMarker.h"

#include "MarkerBuilder.h"
#include "EegeoMarkersApi.h"


@implementation WRLDMarker
{
    Eegeo::Api::EegeoMarkersApi* m_pMarkersApi;
    NSInteger m_markerId;
}

- (instancetype)initWithMarkerOptions:(WRLDMarkerOptions *)markerOptions
                      andAddToMapView:(WRLDMapView*) mapView
{
    self = [super init];
    
    m_pMarkersApi = &[mapView getMapApi].GetMarkersApi();

    Eegeo::Markers::MarkerBuilder builder;
    builder.SetLocation(markerOptions.coordinate.latitude, markerOptions.coordinate.longitude);
    m_markerId = m_pMarkersApi->CreateMarker(builder.Build());
    
    _coordinate = markerOptions.coordinate;
    
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
}

@end
