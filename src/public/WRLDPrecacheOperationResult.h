#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 A result of a precache operation.
 Returned when a precache operation completes via the completionHandler block passed to [mapView precache:radius:completionHandler].
 */
@interface WRLDPrecacheOperationResult : NSObject

/*!
 @returns A boolean indicating whether the precache operation succeeded or not.
 */
- (BOOL) succeeded;

@end

/*!
 The type of the block to be executed when a precache operation completes.  This block takes a single parameter, being the WRLDPrecacheOperationResult which represents the completed precache operation's status.
 */
typedef void (^WRLDPrecacheOperationHandler)(WRLDPrecacheOperationResult* result);

NS_ASSUME_NONNULL_END
