// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>
#import "EGAnnotation.h"


/*!
 @class EGAnnotationView
 @brief Responsible for presenting annotations visually in the eeGeo 3D Map.
 @discussion Annotation views are loosely coupled to a corresponding annotation object, which is an object that corresponds to the EGAnnotationView protocol.
 */
@interface EGAnnotationView : UIView

/*!
 @method initWithAnnotation
 @brief Initializes and returns a new annotation view.
 @param annotation The annotation object to associate with the new view.
 @param reuseIdentifier Optional reuseidentifier; currently not used by the implementation, but may be in future. Pass nil if you do not intend to reuse the view, or pass a value so that the instance can be identified and reused later. Passing a non-nil value is recommended.
 @return The initialized annotation view or nil if there was a problem initializing the object.
 */
- (instancetype)initWithAnnotation:(NSObject <EGAnnotation>*)annotation reuseIdentifier:(NSString *)reuseIdentifier;

/*!
 @method initWithAnnotation
 @brief Initializes and returns a new annotation view.
 @param annotation The annotation object to associate with the new view.
 @return The initialized annotation view or nil if there was a problem initializing the object.
 */
- (void)initWithAnnotation:(NSObject<EGAnnotation>*)annotation;

/*!
 @property reuseIdentifier
 @brief The string that identifies that this annotation view is reusable.
 */
@property (nonatomic, readonly) NSString *reuseIdentifier;

/*!
 @method prepareForReuse
 @brief Currently unused by the implementation, in future will be called when the view is removed from the reuse queue.
 @return Returns nothing.
 */
- (void)prepareForReuse;

/*!
 @property annotation
 @brief The annotation object currently associated with the view.
 */
@property (nonatomic, strong) NSObject <EGAnnotation>* annotation;


/*!
 @property centerOffset
 @brief By default, the center of annotation view is placed over the coordinate of the annotation. centerOffset is the offset in screen points from the center of the annotion view.
*/
@property (nonatomic) CGPoint centerOffset;

/*!
 @property calloutOffset
 @brief calloutOffset is the offset in screen points from the top-middle of the annotation view, where the anchor of the callout should be shown.
 */
@property (nonatomic) CGPoint calloutOffset;

/*!
 @property enabled
 @brief Defaults to YES. If NO, ignores touch events and subclasses may draw differently.
 */
@property (nonatomic, getter=isEnabled) BOOL enabled;

/*!
 @property highlighted
 @brief Defaults to NO. This gets set/cleared automatically when touch enters/exits during tracking and cleared on up.
 */
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

/*!
 @property selected
 @brief Defaults to NO. Becomes YES when tapped/clicked on in the map view, or programatically selected.
 */
@property (nonatomic, getter=isSelected) BOOL selected;

/*!
 @property canShowCallout
 @brief If YES, a standard callout bubble will be shown when the annotation is selected. The annotation must have a title for the callout to be shown.
 */
@property (nonatomic) BOOL canShowCallout;

/*!
 @property leftCalloutAccessoryView
 @brief The left accessory view to be used in the standard callout.
 */
@property (strong, nonatomic) UIView *leftCalloutAccessoryView;

/*!
 @property rightCalloutAccessoryView
 @brief The right accessory view to be used in the standard callout.
 */
@property (strong, nonatomic) UIView *rightCalloutAccessoryView;

/*!
 @method setSelected
 @brief Set selection state for the view.
 @param selected YES for selected, else NO.
 @param animated YES for to animate visual selection state change, else NO to immediately show new state.
 @return Returns nothing.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
