#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WRLDBuildingInformation.h"
#import "WRLDBuildingHighlightOptions.h"

#import "WRLDOverlay.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Represents a single selected building on the map,
 for displaying a graphical overlay to highlight the building, or for obtaining information about
 the building.
 */
@interface WRLDBuildingHighlight : NSObject<WRLDOverlay>

/*!
 Instantiate a highlight with highlight options.
 @param highlightOptions A set of parameters for WRLDBuildingHighlight.
 @returns A WRLDBuildingHighlight instance.
 */
+ (instancetype)highlightWithOptions:(WRLDBuildingHighlightOptions*)highlightOptions;

/*!
 The color for this highlight.
 */
@property (nonatomic, copy) UIColor* color;

/*!
 Returns building information for the map building associated with this highlight, if available.
 Returns null if the request for building information is still pending (internally, building
 information may be fetched asynchronously).
 Also returns nil if no building information was successfully retrieved for this building
 highlight. This may be either because no building exists at the query location supplied in
 the WRLDBuildingHighlightOptions construction parameters, or because an internal web request failed.
 */
@property (nonatomic, readonly, copy, nullable) WRLDBuildingInformation* buildingInformation;

@end

NS_ASSUME_NONNULL_END
