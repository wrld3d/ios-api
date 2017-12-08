#pragma once

#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * An object representing a request for a Mapscene.
 */
@interface WRLDMapsceneRequest: NSObject

/**
 * Cancels the current Mapscene request if not yet completed.
 */
-(void)cancel;

@end

NS_ASSUME_NONNULL_END
