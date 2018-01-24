#import <UIKit/UIKit.h>
#import "WRLDCoordinateWithAltitude.h"

@class WRLDMapView;
@class WRLDMarker;
@class WRLDPositioner;
@class WRLDPoiSearch;
@class WRLDPoiSearchResponse;
@class WRLDMapsceneRequestResponse;
@class WRLDRoutingQuery;
@class WRLDRoutingQueryResponse;
@class WRLDBuildingHighlight;

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

/*!
A message sent when a WRLDPositioner object has changed.
@param mapView The WRLDMapView that is being observed.
@param positioner The WRLDPositioner that has changed.
*/
- (void)mapView:(WRLDMapView *)mapView positionerDidChange: (WRLDPositioner*)positioner;

/*!
A message sent when a POI search completes.
@param mapView The WRLDMapView that is being observed.
@param poiSearchId The ID of the WRLDPoiSearch.
@param poiSearchResponse The POI search results.
 */
- (void)mapView:(WRLDMapView *)mapView poiSearchDidComplete: (int) poiSearchId
poiSearchResponse: (WRLDPoiSearchResponse*) poiSearchResponse;

/*
 A message sent when a mapscene request completes.
 @param mapView the WRLDMapView that is being observed
 @param requestId the ID of the WRLDMapsceneRequest
 @param mapsceneResponse the WRLDMapsceneRequestResponse for this query. If successful, this will contain a valid WRLDMapscene, otherwise nil.
 */
- (void)mapView:(WRLDMapView *)mapView mapsceneRequestDidComplete: (int)requestId mapsceneResponse:(WRLDMapsceneRequestResponse*)mapsceneResponse;

/*!
 A message sent when a routing query completes.
 @param mapView The WRLDMapView that is being observed.
 @param routingQueryId The ID of the WRLDRoutingQuery.
 @param routingQueryResponse The WRLDRoutingQueryResponse for this query. If successful, this will contain routing results.
 */
- (void)mapView:(WRLDMapView *)mapView routingQueryDidComplete: (int) routingQueryId
routingQueryResponse: (WRLDRoutingQueryResponse*) routingQueryResponse;

/*!
 A message sent when a building information is received.
 Access this with [buildingHighlight buildingInformation].
 @param mapView The WRLDMapView that is being observed.
 @param buildingHighlight The WRLDBuildingHighlight object for which WRLDBuildingInformation has been received.
 */
- (void)mapView:(WRLDMapView *)mapView didReceiveBuildingInformationForHighlight: (WRLDBuildingHighlight*) buildingHighlight;

@end
