#pragma once

#import <foundation/foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDViewAnchor : NSObject

/*!
 * Anchors a View to a point relative to its parent. This will anchor a point on the View to a
 * point on its parent. The anchorUV is relative to the size of the View, a value of (0,0) will
 * anchor the top left corner of the view and a value of (1,1) will anchor the bottom right
 * corner of the view. Negative and values larger than 1 are also valid for anchorUV.
 *
 * @param view The View to set the position of.
 * @param screenPoint The point to anchor to, relative to the parent of the View.
 * @param anchorUV The point on the View to use as the anchor point.
 */
+ (void)positionView:(UIView *)view
         screenPoint:(CGPoint *)screenPoint
            anchorUV:(CGPoint *)anchorUV;

@end

NS_ASSUME_NONNULL_END
