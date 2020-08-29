#pragma once

#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Defines creation parameters for a RouteView. The styling options match with those of the PolylineOptions class
 */
@interface WRLDRouteViewOptions : NSObject

/*!
 * Sets the width of the RouteView's polylines in screen pixels.
 *
 * @param width The width in screen pixels.
 * @return The RouteViewOptions object on which the method was called, with the new width set.
 */
- (WRLDRouteViewOptions*) width:(CGFloat)width;

/*!
 * Sets the color of the RouteView's polylines as a 32-bit ARGB color. The default value is opaque blue (0xff0096ff).
 *
 * @param color The color to use.
 * @return The RouteViewOptions object on which the method was called, with the new color set.
 */
- (WRLDRouteViewOptions*) color:(UIColor*)color;

/*!
* Sets the forward path color of the RouteView's polylines as a 32-bit ARGB color. The default value is opaque green (0xff00ff96).
*
* @param color The color to use.
* @return The RouteViewOptions object on which the method was called, with the new color set.
*/
- (WRLDRouteViewOptions*) forwardPathColor:(UIColor*)color;

/*!
 * Sets the miter limit of the RouteView's polylines, the maximum allowed ratio between the length of a miter
 * diagonal at a join, and the line width.
 *
 * @param miterLimit The miter limit.
 * @return The RouteViewOptions object on which the method was called, with the new miter limit set.
 */
- (WRLDRouteViewOptions*) miterLimit:(CGFloat)miterLimit;

- (CGFloat) getWidth;

- (UIColor*) getColor;

-(UIColor*) getForwardPathColor;

- (CGFloat) getMiterLimit;

@end

NS_ASSUME_NONNULL_END
