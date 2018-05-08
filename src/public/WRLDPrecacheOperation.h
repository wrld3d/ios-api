#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A handle to an ongoing precache operation.
 */
@interface WRLDPrecacheOperation : NSObject

/*!
 Cancels the current precache operation if it has not yet been completed.
 */
- (void)cancel;

/*!
 @returns The ID of this precache operation.
 */
- (int)precacheOperationId;

@end

NS_ASSUME_NONNULL_END
