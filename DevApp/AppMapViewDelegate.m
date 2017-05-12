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

- (void)mapView:(WRLDMapView *)mapView didTapMarker:(WRLDMarker *)marker
{
    NSLog(@"AppMapViewDelegate - marker tapped: %@", marker.title);
}

@end


