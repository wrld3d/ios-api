#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CGGeometry.h>

#import "WRLDScreenProperties.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Options used to construct a WRLDBuildingHighlight object.
 */
@interface WRLDBuildingHighlightOptions : NSObject

/*!
 Instantiate highlight options to attempt to highlight any building present at the given CLLocationCoordinate2D location.
 @param location  The location.
 @returns A WRLDBuildingHighlightOptions instance.
 */
+ (instancetype) highlightOptionsWithLocation:(CLLocationCoordinate2D)location;

/*!
 Instantiate highlight options to attempt to highlight any building present at the given screen point for the
 current map view.
 @param screenPoint The screen-space point.
 @param screenProperties Screen properties from WRLDMapView.
 @returns A WRLDBuildingHighlightOptions instance.
 */
+ (instancetype) highlightOptionsWithScreenPoint:(CGPoint)screenPoint
                                screenProperties:(WRLDScreenProperties)screenProperties;

/*!
 Sets the color of the building highlight as a UIColor. The default value is black.

 @param color The color to use.
 */
- (void) setColor:(UIColor*)color;

/*!
 Sets options such that, if a WRLDBuildingHighlight object is created with these options and added
 to a map, it will not result in any visual highlight overlay being displayed. In this case,
 the WRLDBuildingHighlight object is used only for the purpose of retrieving WRLDBuildingInformation.
 */
- (void) informationOnly;

@end

NS_ASSUME_NONNULL_END

