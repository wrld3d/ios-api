#import "AppMapViewDelegate.h"

@import Wrld;

@implementation AppMapViewDelegate

- (void)initialMapSceneLoaded:(WRLDMapView *)mapView
{
    NSLog(@"AppMapViewDelegate - streaming of initial map scene completed.");
}

- (void)didTapMarker:(WRLDMarker *)marker
{
    NSLog(@"AppMapViewDelegate - marker tapped: %@", marker.title);
}

@end


