#pragma once

#import <GLKit/GLKit.h>
#import <CoreLocation/CoreLocation.h>

#import "WRLDMapViewDelegate.h"
#import "WRLDIndoorMapDelegate.h"
#import "WRLDMapCamera.h"
#import "WRLDCoordinateBounds.h"
#import "WRLDIndoorMap.h"
#import "WRLDMarker.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WRLDMapViewDelegate;

/// A view which displays a 3D map. Also exposes most of the methods for manipulating the map.
@interface WRLDMapView : UIView

/*! @name Initialization */

/// A <WRLDMapViewDelegate> object to receive events from this view. Can be wired up in Interface Builder.
@property(nonatomic, weak, nullable) IBOutlet id<WRLDMapViewDelegate> delegate;

/*!
 Allocates and initializes a new <WRLDMapView> object with the given frame.
 @param frame The frame rectangle for the view, measured in pts.
 @returns The initialized view.
 */
- (instancetype) initWithFrame: (CGRect)frame;



#pragma mark - manipulating the visible portion of the map -


/*! @name View properties */

/// The coordinate at the center of the map view.
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/// The zoom level of the map.
@property (nonatomic) double zoomLevel;

/// The heading of the map.
@property (nonatomic) CLLocationDirection direction;

/// The <WRLDMapCamera> represents the current view of the map.
@property (nonatomic, copy) WRLDMapCamera *camera;


/*! @name View methods */

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  direction:(CLLocationDirection)direction
                   animated:(BOOL)animated;

/*!
 Set the center coordinate, and optionally the zoom level and heading, of the map.
 @param coordinate The LatLong coordinate to look at.
 @param zoomLevel How zoomed in the resulting view should be.
 @param direction The new heading of the map.
 @param animated YES to animate smoothly to the new camera state, NO to snap immediately. Note that if the specified location is too far away from the current camera location, this parameter will be ignored and the camera will snap the new location.
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                  direction:(CLLocationDirection)direction
                   animated:(BOOL)animated;


- (void)setZoomLevel:(double)zoomLevel;

/*!
 Set the zoom level of the map, optionally animating from the current zoom level.
 @param zoomLevel The target zoom level.
 @param animated Whether to animate this transition, or just snap to the destination zoom level.
 */
- (void)setZoomLevel:(double)zoomLevel
            animated:(BOOL)animated;

/*!
 Set the heading of the map, optionally animating from the current heading.
 @param direction The target heading direction.
 @param animated Whether to animate this transition, or just snap to the destination heading.
 */
- (void)setDirection:(double)direction
            animated:(BOOL)animated;


- (void)setCamera:(WRLDMapCamera *)camera;

/*!
 Set the camera of the map, optionally animating from the current view.
 @param camera The target <WRLDMapCamera>.
 @param animated Whether to animate this transition, or just snap to the new map view.
 */
- (void)setCamera:(WRLDMapCamera *)camera animated:(BOOL)animated;

/*!
 Set the camera of the map, animating for the supplied duration.
 @param camera The target <WRLDMapCamera>.
 @param duration The length of time for the transition to take.
 */
- (void)setCamera:(WRLDMapCamera *)camera duration:(NSTimeInterval)duration;

/*!
 Position the camera to encapsulate a bounded region.
 @param bounds Instance of an [WRLDCoordinateBounds](/docs/api/Others/WRLDCoordinateBounds.html) object, which describes the region to encapsulate.
 @param animated YES to animate smoothly to the new camera state, NO to snap immediately. Note that if the region is too far away from the current camera location, this parameter will be ignored and the camera will snap the new location.
 */
- (void)setCoordinateBounds:(WRLDCoordinateBounds)bounds animated:(BOOL)animated;


#pragma mark - markers -

/*! @name Markers */

/*!
 Add a marker to the map.
 @param marker The <WRLDMarker> object to add.
 */
- (void)addMarker:(WRLDMarker *)marker;

/*!
 Add multiple markers to the map.
 @param markers An array of <WRLDMarker> objects to add to the map.
 */
- (void)addMarkers:(NSArray <WRLDMarker *> *)markers;

/*!
 Remove a marker from the map.
 @param marker The <WRLDMarker> to remove from the map.
 */
- (void)removeMarker:(WRLDMarker *)marker;

/*!
 Remove multiple markers from the map.
 @param markers An array of <WRLDMarker> objects to remove from the map.
 */
- (void)removeMarkers:(NSArray <WRLDMarker *> *)markers;


#pragma mark - controlling the indoor map view -


/*! @name Indoor Map properties */

/// An object implementing the <WRLDIndoorMapDelegate> protocol to receive events when entering or exiting an indoor map.
@property(nonatomic, weak, nullable) IBOutlet id<WRLDIndoorMapDelegate> indoorMapDelegate;

/// The currently active indoor map, or `nil` if currently outdoors.
@property(nonatomic, readonly, copy, nullable) WRLDIndoorMap* activeIndoorMap;


/*! @name Indoor Map methods */


/*!
 Enter an indoor map with the given ID.
 @param indoorMapId The ID of an indoor map as an NSString. See <WRLDIndoorMap> for details.
 */
- (void)enterIndoorMap:(NSString*)indoorMapId;

/*!
 Exit the current indoor map, if indoors.
 */
- (void)exitIndoorMap;

/*!
 Check if the map view is currently indoors.
 @returns YES if currently in an indoor map, NO otherwise.
 */
- (BOOL)isIndoors;

/*!
 Get the index of the current active floor, relative to the ground floor.
 @returns The current floor index as an NSInteger.
 */
- (NSInteger)currentFloorIndex;

/*!
 Set the currently active floor to the one corresponding to the given index.
 @param floorIndex The floor index to make active as an NSInteger.
 */
- (void)setFloorByIndex:(NSInteger)floorIndex;

/*!
 Move up one floor in an indoor map.
 */
- (void)moveUpFloor;

/*!
 Move down one floor in an indoor map.
 */
- (void)moveDownFloor;

/*!
 Move up multiple floors in an indoor map.
 @param numberOfFloors The number of floors to move as an NSInteger.
 */
- (void)moveUpFloors:(NSInteger)numberOfFloors;

/*!
 Move down multiple floors in an indoor map.
 @param numberOfFloors The number of floors to move as an NSInteger.
 */
- (void)moveDownFloors:(NSInteger)numberOfFloors;

/*!
 Enter the expanded view of an indoor map.
 */
- (void)expandIndoorMapView;

/*!
 Collapse the expanded view of an indoor map, returning to the default view.
 */
- (void)collapseIndoorMapView;

/*!
 Sets the interpolation value used in the expanded indoor view.
 @param floorInterpolation A CGFloat between 0.0 and the number of floors in the active <WRLDIndoorMap> object.
 */
- (void)setFloorInterpolation:(CGFloat)floorInterpolation;

@end

NS_ASSUME_NONNULL_END
