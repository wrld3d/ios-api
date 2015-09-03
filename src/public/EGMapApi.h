// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "EGAnnotation.h"
#import "EGMapTheme.h"
#import "EGPointAnnotation.h"
#import "EGPolygon.h"
#import "EGCoordinateBounds.h"
#import "EGPrecacheOperation.h"
#import "EGAnnotationView.h"

/*!
 @protocol EGMapApi
 @brief The main interface for applications to interact with the eeGeo 3D Map.
 @discussion The EGMapApi protocol exposes the main API points for manipulating the map.
 
 Complementary methods are presented to add and remove features to the map, including annotations and polygons. Methods to manipulate and move the camera are presented on the EGMapApi.
 
 An instance of the EGMapView is provided to the the caller via the EGMapDelegate property of EGMapView, when the API is ready and available to use.
*/
@protocol EGMapApi<NSObject>

/*!
 @method polygonWithCoordinates
 @brief Create an object implementing the EGPolygon protocol from a collection of coordinates. The points are connected end-to-end in the order they are provided. The first and last points are connected to each other to create the closed shape.
 @param coords Array of coordinate values.
 @param count Number of coordinate values.
 @return Pointer to EGPolygon instance.
*/
- (id<EGPolygon>)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;

/*!
 @method addPolygon
 @brief Add EGPolygon instance to the map.
 @param polygon Pointer to EGPolygon instance.
 @return Returns nothing.
 */
- (void)addPolygon:(id<EGPolygon>)polygon;

/*!
 @method removePolygon
 @brief Remove EGPolygon instance from the map.
 @param polygon Pointer to EGPolygon instance.
 @return Returns nothing.
 */
- (void)removePolygon:(id <EGPolygon>)polygon;

/*!
 @method setCenterCoordinate
 @brief Position the camera to look at the a particular location, at the provided distance and orientation.
 @param centerCoordinate The WGS84 coordinate to look at.
 @param distanceMetres The distance the camera should be positioned from the centerCoordinate in metres.
 @param orientationDegrees The orientation of the camera from north in degrees (0 is north aligned).
 @param animated YES to animate smoothly to the new camera state, NO to snap immediately. Note that if the specified location is too far away from the current camera location, this parameter will be ignored and the camera will snap the new location.
 @return Returns nothing.
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
             distanceMetres:(float)distanceMetres
         orientationDegrees:(float)orientationDegrees
                   animated:(BOOL)animated;

/*!
 @method addAnnotation
 @brief Add an EGAnnotation instance from the map.
 @param annotation Pointer to EGAnnotation instance.
 @return Returns nothing.
 */
- (void)addAnnotation:(id<EGAnnotation>)annotation;

/*!
 @property selectedAnnotations
 @brief Get the collection of selected EGAnnotation instances from the map.
 */
@property(nonatomic, copy) NSArray *selectedAnnotations;

/*!
 @method selectAnnotation
 @brief Programatically select an EGAnnotation instance that has already been to added the map. Selecting an annotation will deselect the currently selected annotation, if there is one. Deselection and selection handlers in the EGMapDelegate will be called.
 @param annotation Pointer to EGAnnotation instance, which has previously been added to the map.
 @param animated YES to play the annotation selection animation, NO to snap immediately.
 @return Returns nothing.
 */
- (void)selectAnnotation:(id<EGAnnotation>)annotation animated:(BOOL)animated;

/*!
 @method deselectAnnotation
 @brief Programatically deselect an EGAnnotation instance that has already been to added the map. The deselection handler in the EGMapDelegate will be called.
 @param annotation Pointer to EGAnnotation instance, which has previously been added to the map.
 @param animated YES to play the annotation deselection animation, NO to snap immediately.
 @return Returns nothing.
 */
- (void)deselectAnnotation:(id<EGAnnotation>)annotation animated:(BOOL)animated;

/*!
 @method removeAnnotation
 @brief Remove an EGAnnotation instance from the map.
 @param annotation Pointer to EGAnnotation instance.
 @return Returns nothing.
 */
- (void)removeAnnotation:(id<EGAnnotation>)annotation;

/*!
 @method viewForAnnotation
 @brief Get a (weak) pointer to the EGAnnotationView corresponding to an EGAnnotation instance that has already been to added the map.
 @param annotation Pointer to EGAnnotation instance.
 @return Returns a pointer to corresponding EGAnnotationView instance for annotation.
 */
- (EGAnnotationView*)viewForAnnotation:(id<EGAnnotation>)annotation;

/*!
 @method setVisibleCoordinateBounds
 @brief Position the camera to encapsulate a bounded region.
 @param bounds Instance of an EGCoordinateBounds object, which describes the region to encapsulate.
 @param animated YES to animate smoothly to the new camera state, NO to snap immediately. Note that if the region is too far away from the current camera location, this parameter will be ignored and the camera will snap the new location.
 @return Returns nothing.
*/
- (void)setVisibleCoordinateBounds:(EGCoordinateBounds)bounds animated:(BOOL)animated;

/*!
 @method precacheMapDataInCoordinateBounds
 @brief Start an asynchronous download task to gather all map data within the specified region.
 @param bounds Instance of an EGCoordinateBounds object, which describes the region to precache.
 @return Pointer to an EGPrecacheOperation instance.
 */
- (id<EGPrecacheOperation>)precacheMapDataInCoordinateBounds:(EGCoordinateBounds)bounds;

/*!
 @method setMapTheme
 @brief Set the map theme, which controls the visual presentation of the map. This includes texturing of the environment, lighting, time of day, and weather effects.
 @param mapTheme Instance of an EGMapTheme object, representing the theme to switch to.
 @return Returns nothing.
 */
- (void)setMapTheme:(EGMapTheme*)mapTheme;

/*!
 @method setEnvironmentFlatten
 @brief Toggle whether the map is vertically 3D, or flattened vertically to appear more 2D. Can be useful to enhance ease of navigation by showing streets which are occluded by buildings.
 @param flatten YES to flatten the environment, NO to display the environment in full 3D.
 @return Returns nothing.
 */
- (void)setEnvironmentFlatten:(BOOL)flatten;

@end
