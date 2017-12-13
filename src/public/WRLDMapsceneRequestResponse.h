#pragma once

#import <Foundation/Foundation.h>
#import "WRLDMapscene.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 * A response to the mapscene Request. This is returned when a mapscene request completes via a callback.
 */
@interface WRLDMapsceneRequestResponse : NSObject

/// A boolean indicating wheather the request succeeded. True if the request was successful, else false.
@property (readonly) bool succeeded;

/// Holds the resulting mapscene from the request to the mapscene service.
@property (readonly) WRLDMapscene* mapscene;

@end

NS_ASSUME_NONNULL_END
