#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WRLDIndoorMapEntity.h"

#import "WRLDOverlay.h"
#import "WRLDIndoorMapEntityLoadState.h"


NS_ASSUME_NONNULL_BEGIN

/*!
 *  Maintains information about indoor map entities belonging to an indoor map with the specified id.
 *  Entity information is updated as map tiles stream in.
 */
@interface WRLDIndoorMapEntityInformation : NSObject<WRLDOverlay>

/*!
 Instantiate a WRLDIndoorMapEntityInformation object to retrieve entity information for an indoor map.
 @param indoorMapId The string id of the indoor map to retrieve entity information for.
 @returns The WRLDIndoorMapEntityInformation instance.
 */
+ (instancetype)informationForIndoorMap:(NSString *)indoorMapId;

/// The string id of the indoor map associated with this IndoorMapEntityInformation object.
@property (nonatomic, readonly, copy) NSString* indoorMapId;

/*!
 An array of WRLDIndoorMapEntity objects, representing the currently loaded indentifiable features 
 for the associated indoor map.
 */
@property (nonatomic, readonly, copy) NSArray<WRLDIndoorMapEntity*>* indoorMapEntities;

/// The current streaming status for the associated indoor map.
@property (nonatomic, readonly) WRLDIndoorMapEntityLoadState loadState;

@end

NS_ASSUME_NONNULL_END
