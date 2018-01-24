#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WRLDBuildingInformation.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Represents a single selected building on the map,
 for displaying a graphical overlay to highlight the building, or for obtaining information about
 the building.
 */
@interface WRLDBuildingHighlight : NSObject

/*!
 @returns The color of the highlight.
 */
- (UIColor*) color;

/*!
 Sets the color for this highlight.

 @param color The color of the highlight.
 */
- (void) setColor:(UIColor*)color;

/*!
 Returns building information for the map building associated with this highlight, if available.
 Returns null if the request for building information is still pending (internally, building
 information may be fetched asynchronously).
 Also returns nil if no building information was successfully retrieved for this building
 highlight. This may be either because no building exists at the query location supplied in
 the WRLDBuildingHighlightOptions construction parameters, or because an internal web request failed.
 @return the WRLDBuildingInformation associated with this highlight, or null.
 */
- (nullable WRLDBuildingInformation*) buildingInformation;

@end

NS_ASSUME_NONNULL_END
