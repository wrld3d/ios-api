#pragma once

@import Wrld;


@interface AppMapViewDelegate : NSObject<WRLDMapViewDelegate>

- (WRLDOverlayRenderer *)mapView:(WRLDMapView *)mapView rendererForOverlay:(id <WRLDOverlay>)overlay;


@end
