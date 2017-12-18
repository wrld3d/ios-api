#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A handle to an ongoing routing service query.
 */
@interface WRLDRoutingQuery : NSObject

/*!
 Cancels the current query if it has not yet been completed.
 */
- (void)cancel;

/*!
 @returns The ID of this query.
 */
- (int)routingQueryId;

@end

NS_ASSUME_NONNULL_END
