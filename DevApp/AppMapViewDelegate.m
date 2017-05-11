#import "AppMapViewDelegate.h"

@import Wrld;

@implementation AppMapViewDelegate

- (void)mapViewDidFinishLoadingInitialMap:(WRLDMapView *)mapView
{
    NSLog(@"AppMapViewDelegate - streaming of initial map scene completed.");
}

- (void)mapView:(WRLDMapView *)mapView didTapMarker:(WRLDMarker *)marker
{
    NSLog(@"AppMapViewDelegate - marker tapped: %@", marker.title);
}

@end


