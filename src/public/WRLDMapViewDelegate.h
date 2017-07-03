#import <UIKit/UIKit.h>
#import "WRLDCoordinateWithAltitude.h"

@class WRLDMapView;
@class WRLDMarker;

/*!
 This protocol defines an interface for observing a WRLDMapView for events.
 You can optionally implement these methods to receive messages from the map.
 */
@protocol WRLDMapViewDelegate <NSObject>

@optional

/*!
 A message sent before the map view is changed, whether by a user or an API call.
 @param mapView The WRLDMapView that is being observed.
 */
- (void)mapViewRegionWillChange:(WRLDMapView *)mapView;

/*!
 A message sent every frame while the map view is changing. For example, during an animated camera transition.
 @param mapView The WRLDMapView that is being observed.
 */
- (void)mapViewRegionIsChanging:(WRLDMapView *)mapView;

/*!
 A message sent when the map view has finished changing. For example, when a camera transition ends.
 @param mapView The WRLDMapView that is being observed.
 */
- (void)mapViewRegionDidChange:(WRLDMapView *)mapView;

/*!
 A message sent when the map has finished streaming the minimum resources required to display the initial view.
 @param mapView The WRLDMapView that is being observed.
 */
- (void)mapViewDidFinishLoadingInitialMap:(WRLDMapView *)mapView;

/*!
 Notifies the delegate that the user has tapped a point on the map.
 @param mapView The map view that has been tapped
 @param coordinateWithAltitude The location on the terrain of the tapped point.
 */
- (void)mapView:(WRLDMapView *)mapView didTapMap:(WRLDCoordinateWithAltitude)coordinateWithAltitude;

/*!
 A message sent when the user has tapped a marker on the map.
 @param mapView The WRLDMapView that is being observed.
 @param marker The WRLDMarker that was tapped.
 */
- (void)mapView:(WRLDMapView *)mapView didTapMarker:(WRLDMarker *)marker;

@end
