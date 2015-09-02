// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <GLKit/GLKit.h>
#import "EegeoMapDelegate.h"

/*!
 @class EegeoMapView
 @brief The main view for the eeGeo 3D Map.
 @discussion The EegeoMapView is a UIView subclass that can be added to the application view hierarchy. It contains the surface that the eeGeo 3D map is rendered to. Adding a EegeoMapView to the view hierarchy begins the process of constructing the EegeoMapApi instance, which will be made available to the application via the EegeoMapDelegate delegate. 

 The use of an EegeoMapView requires an API key, obtainable from https://www.eegeo.com/developers/apikeys. To supply the key, ensure that it is registered against 'eeGeoMapsApiKey' in the info dictionary for the mainBundle (such as by adding a plist entry, or explicitly setting the value).
 */
@interface EegeoMapView : GLKView<UIGestureRecognizerDelegate>

/*!
 @method initWithFrame
 @brief Initializes and returns a newly allocated view object with the specified frame rectangle.
 @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 */
- (id)initWithFrame:(CGRect)frame;

/*!
 @property eegeoMapDelegate
 @brief Should be set by the application to get an instance of the EegeoMapApi. Also specifies optional methods to handle various map events.
 */
@property(retain, nonatomic) id<EegeoMapDelegate> eegeoMapDelegate;

@end
