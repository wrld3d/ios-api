#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A handle to an ongoing search.
 */
@interface WRLDPoiSearch : NSObject

/*!
 Cancels the current search if it has not yet completed.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
