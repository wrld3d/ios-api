#pragma once

#import <GLKit/GLKit.h>
#import <CoreLocation/CoreLocation.h>

#import "WRLDMapViewDelegate.h"
#import "WRLDMapCamera.h"
#import "WRLDCoordinateBounds.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WRLDMapViewDelegate;


@interface WRLDMapView : UIView


- (instancetype)initWithFrame:(CGRect)frame;


@property(nonatomic, weak, nullable) IBOutlet id<WRLDMapViewDelegate> delegate;


#pragma mark - manipulating the visible portion of the map -


/*! The coordinate at the center of the map view.
 */
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/*!
 @brief Centers the map about a coordinate without changing the current zoom level, and optionally animating from the current location.
 @param coordinate The LatLong coordinate to look at.
 @param animated YES to animate smoothly to the new camera state, NO to snap immediately. Note that if the specified location is too far away from the current camera location, this parameter will be ignored and the camera will snap the new location.
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  direction:(CLLocationDirection)direction
                   animated:(BOOL)animated;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(double)zoomLevel
                  direction:(CLLocationDirection)direction
                   animated:(BOOL)animated;


/*! The zoom level of the map.
 */
@property (nonatomic) double zoomLevel;

- (void)setZoomLevel:(double)zoomLevel
            animated:(BOOL)animated;


/*! The heading of the map.
 */
@property (nonatomic) CLLocationDirection direction;

- (void)setDirection:(double)direction
            animated:(BOOL)animated;


/*!
 @method setCoordinateBounds
 @brief Position the camera to encapsulate a bounded region.
 @param bounds Instance of an WRLDCoordinateBounds object, which describes the region to encapsulate.
 @param animated YES to animate smoothly to the new camera state, NO to snap immediately. Note that if the region is too far away from the current camera location, this parameter will be ignored and the camera will snap the new location.
 */
- (void)setCoordinateBounds:(WRLDCoordinateBounds)bounds animated:(BOOL)animated;


/*! The camera represents the current view of the map.
 */
@property (nonatomic, copy) WRLDMapCamera *camera;

- (void)setCamera:(WRLDMapCamera *)camera;

- (void)setCamera:(WRLDMapCamera *)camera animated:(BOOL)animated;

- (void)setCamera:(WRLDMapCamera *)camera duration:(NSTimeInterval)duration;


#pragma mark - controlling the indoor map view -

- (void)enterIndoorMap:(NSString*)indoorMapId;

- (void)exitIndoorMap;

- (BOOL)isIndoors;

- (int)currentFloorIndex;

- (void)setFloorByIndex:(int)floorIndex;

- (void)moveUpFloor;

- (void)moveDownFloor;

- (void)moveUpFloors:(int)numberOfFloors;

- (void)moveDownFloors:(int)numberOfFloors;

- (void)expandIndoorMapView;

- (void)collapseIndoorMapView;

@end

NS_ASSUME_NONNULL_END
