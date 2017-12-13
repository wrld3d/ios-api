#pragma once

#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 * An object representing a request for a mapscene.
 */
@interface WRLDMapsceneRequest: NSObject

/*!
 * Cancels the current mapscene request if not yet completed.
 */
-(void)cancel;

@end

NS_ASSUME_NONNULL_END
