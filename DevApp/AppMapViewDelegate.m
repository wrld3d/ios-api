#import "AppMapViewDelegate.h"

@import Wrld;

@implementation AppMapViewDelegate
    
- (void)mapViewRegionWillChange:(WRLDMapView *)mapView
{
    NSLog(@"AppMapViewDelegate - map view region will change.");
}
    
- (void)mapViewRegionDidChange:(WRLDMapView *)mapView
{
    NSLog(@"AppMapViewDelegate - map view region did change.");
}

- (void)mapViewDidFinishLoadingInitialMap:(WRLDMapView *)mapView
{
    NSLog(@"AppMapViewDelegate - streaming of initial map view completed.");
}

- (void)mapView:(WRLDMapView *)mapView didTapMap:(WRLDCoordinateWithAltitude)coordinateWithAltitude
{
    NSLog(@"AppMapViewDelegate - didTapMap: %f, %f, %f", coordinateWithAltitude.coordinate.latitude, coordinateWithAltitude.coordinate.longitude, coordinateWithAltitude.altitude);
}

- (void)mapView:(WRLDMapView *)mapView didTapMarker:(WRLDMarker *)marker
{
    NSLog(@"AppMapViewDelegate - marker tapped: %@", marker.title);
}

- (WRLDOverlayRenderer *)mapView:(WRLDMapView *)mapView rendererForOverlay:(id <WRLDOverlay>)overlay;
{
    if ([overlay isKindOfClass:[WRLDPolygon class]])
    {
        WRLDPolygonRenderer* renderer = [[WRLDPolygonRenderer alloc] initWithPolygon:(WRLDPolygon*)overlay];
        
        renderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        
        return renderer;
    }
    
    return nil;
}

@end


