#pragma once

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Result values returned by WRLDMap when indoor entities are tapped
 */
@interface WRLDIndoorEntityTapResult : NSObject

/*!
 The screen point that was tapped
 */
@property (nonatomic, readonly) CGPoint screenPoint;

/*!
 The ID of indoor map which contains the indoor entities that were tapped
 */
@property (nonatomic, readonly, copy) NSString* indoorMapId;

/*!
 The ID(s) of indoor entities that were tapped
 */
@property (nonatomic, readonly, copy) NSArray<NSString*>* indoorEntityIds;

@end

NS_ASSUME_NONNULL_END
