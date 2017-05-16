#import <UIKit/UIKit.h>

@class WRLDMapView;
@class WRLDMarker;

//! define optional methods which can be implemented in order to receive update messages from the map

@protocol WRLDMapViewDelegate <NSObject>

@optional
    
- (void)mapViewRegionWillChange:(WRLDMapView *)mapView;
    
- (void)mapViewRegionIsChanging:(WRLDMapView *)mapView;
    
- (void)mapViewRegionDidChange:(WRLDMapView *)mapView;

- (void)mapViewDidFinishLoadingInitialMap:(WRLDMapView *)mapView;

- (void)mapView:(WRLDMapView *)mapView didTapMarker:(WRLDMarker *)marker;

@end