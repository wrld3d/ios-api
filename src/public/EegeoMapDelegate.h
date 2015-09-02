// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EegeoMapApi.h"
#import "EGAnnotationView.h"

/*!
 @protocol EegeoMapDelegate
 @brief Provides applications with the means to handle events from the eeGeo 3D Map, and provide customisation.
 @discussion The EegeoMapDelegate protocol presents the EegeoMapApi instance associated with an EegeoMapView to the application, and allows the application to optionally handle events and provide customisation to the map.
 */
@protocol EegeoMapDelegate<NSObject>

- (void)eegeoMapReady:(id<EegeoMapApi>)api;

@optional

/*!
 @method precacheOperationCompleted
 @brief Handle the completion of a precache operation. This
 @param precacheOperation Pointer to EGPrecacheOperation instance.
 @return Returns nothing.
 */
- (void)precacheOperationCompleted:(id<EGPrecacheOperation>)precacheOperation;

/*!
 @method viewForAnnotation
 @brief Provides an opportunity to specify a custom view for the annotation, rather that using the default eeGeo pin texture annotation view.
 @param annotation Pointer to EGAnnotation instance.
 @return nil to use the default view, otherwise an instance of a UIView to use as a custom annotation view.
 */
- (EGAnnotationView*)viewForAnnotation:(id<EGAnnotation>)annotation;

/*!
 @method didSelectAnnotation
 @brief Handle the selection of an annotation. Selection may have occurred programatically via the EegeoMapApi, or via a user interaction.
 @param annotation Pointer to EGAnnotation instance.
 @return Returns nothing.
 */
- (void)didSelectAnnotation:(id<EGAnnotation>)annotation;

/*!
 @method didDeselectAnnotation
 @brief Handle the deselection of an annotation. Deselection may have occurred programatically via the EegeoMapApi, or via a user interaction.
 @param annotation Pointer to EGAnnotation instance.
 @return Returns nothing.
 */
- (void)didDeselectAnnotation:(id<EGAnnotation>)annotation;

/*!
 @method shouldUseEegeoPinTextureAnnotation
 @brief Specify whether the eeGeo pin texture should be used for a particular annotation, and if so which texture index to use.
 @param annotation Pointer to EGAnnotation instance.
 @param eegeoPinTexturePageIndex Output parameter used to convey the index of the pin in the eeGeo pin texture to use, if the eeGeo pin texture is used.
 @return YES to use the eeGeo pin texture with the texture index specified by eegeoPinTexturePageIndex, NO if a custom view is to be used for the annotation; in this case, viewForAnnotation should be implemented to yield the custom view.
 */
- (BOOL)shouldUseEegeoPinTextureAnnotation:(id<EGAnnotation>)annotation eegeoPinTexturePageIndex:(NSInteger*)eegeoPinTexturePageIndex;

@end
