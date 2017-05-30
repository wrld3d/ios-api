#pragma once

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN


/// A Polygon is an TODO: Document
@interface WRLDPolygon : NSObject

/*!
 Instantiate a polygon with coordinates.
 @param coordinates The coordinate to place this marker at.
 @param count
 @returns A WRLDPolygon instance.
 */
+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coordinates
                                 count:(NSUInteger)count;

/// The coordinates of the polygon.
@property (nonatomic) CLLocationCoordinate2D* coordinates;

/*!
 @method setColor
 @brief Set the color of the polygon, which will be used when drawing.
 @discussion This method allows setting the contribution of the red, green, and blue components, as well as the alpha (transparency) component.
 
 Parameter values of (1.f, 1.f, 1.f 1.f) correspond to fully opaque white.
 Parameter values of (0.f, 0.f, 0.f 1.f) correspond to fully opaque black.
 Parameter values of (1.f, 0.f, 0.f 0.5f) correspond to half-transparent red.
 
 @param r The red component of the color. Valid values range from 0.f (no red) to 1.f (full red).
 @param g The green component of the color. Valid values range from 0.f (no green) to 1.f (full green).
 @param b The blue component of the color. Valid values range from 0.f (no blue) to 1.f (full blue).
 @param a The alpha component of the color. Valid values range from 0.f (fully transparent) to 1.f (fully opaque).
*/
- (void)setColor:(double)r
               g:(double)g
               b:(double)b
               a:(double)a;

- (void)setColor:(double)r
               g:(double)g
               b:(double)b;

@end

NS_ASSUME_NONNULL_END
