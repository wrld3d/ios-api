// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <GLKit/GLKit.h>
#import "EGMapDelegate.h"

/*!
 @class EGMapView
 @brief The main view for the eeGeo 3D Map.
 @discussion The EGMapView is a UIView subclass that can be added to the application view hierarchy. It contains the surface that the eeGeo 3D map is rendered to. Adding an EGMapView to the view hierarchy begins the process of constructing the EGMapApi instance, which will be made available to the application via the EGMapDelegate delegate.

 The use of an EGMapView requires an API key, obtainable from https://www.eegeo.com/developers/apikeys. To supply the key, ensure that it is registered against 'eeGeoMapsApiKey' in the info dictionary for the mainBundle (such as by adding a plist entry, or explicitly setting the value).
 */
@interface EGMapView : GLKView<UIGestureRecognizerDelegate>

/*!
 @method initWithFrame
 @brief Initializes and returns a newly allocated view object with the specified frame rectangle.
 @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 @return Initialised EGMapView instance, or nil if there was a problem.
 */
- (id)initWithFrame:(CGRect)frame;

/*!
 @method initWithFrame
 @brief Initializes and returns a newly allocated view object with the specified frame rectangle.
 @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 @param useCachedResources Flag to indicate whether global map resource cached should be used. Default is YES. Set to YES to retain expensive to create resources, improving loading time on re-entry and preserving scene state. Set to NO to help conserve memory, as resources will be released when the view is removed.
 @return Initialised EGMapView instance, or nil if there was a problem.
 */
- (id)initWithFrame:(CGRect)frame :(BOOL)useCachedResources;

/*!
 @property eegeoMapDelegate
 @brief Should be set by the application to get an instance of the EGMapApi. Also specifies optional methods to handle various map events.
 */
@property(retain, nonatomic) id<EGMapDelegate> eegeoMapDelegate;

@end
