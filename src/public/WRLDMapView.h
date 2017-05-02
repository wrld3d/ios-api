#pragma once

#import <GLKit/GLKit.h>
#import <CoreLocation/CoreLocation.h>

#import "WRLDMapViewDelegate.h"

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


#pragma mark - controlling the indoor map view -

- (void)exitIndoorMap;

- (BOOL)isIndoors;

- (int)currentFloorIndex;

- (void)setFloorByIndex:(int)floorIndex;

- (void)moveUpFloor;

- (void)moveDownFloor;

- (void)moveUpFloors:(int)numberOfFloors;

- (void)moveDownFloors:(int)numberOfFloors;

@end

NS_ASSUME_NONNULL_END
