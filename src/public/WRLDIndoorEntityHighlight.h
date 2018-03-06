#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WRLDOverlay.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Represents a single selected indoor entity highligh on the map.
 */
@interface WRLDIndoorEntityHighlight : NSObject<WRLDOverlay>

/*!
 Instantiate an indoor entity highlight.
 @param indoorEntityId The Id of the entity to be highlighted.
 @param indoorMapId The Id of the indoor map which contains the entity Id.
 @param color The color of this highlight.
 @returns A WRLDIndoorEntityHighlight instance.
 */
+ (instancetype)indoorEntityHighlightWithId:(NSString*)indoorEntityId
                                indoorMapId:(NSString*)indoorMapId
                                      color:(UIColor*)color;

/*!
 The color for this indoor entity highlight.
 */
@property (nonatomic, copy) UIColor* color;

@end

NS_ASSUME_NONNULL_END
