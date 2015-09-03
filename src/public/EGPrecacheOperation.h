// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

/*!
 @protocol EGPrecacheOperation
 @brief Provides an interface to a precache operation. 
 @discussion Precache operations are unobtrusive, and not interrupt user streaming. They are prioritised to only download resources when other resources are is not streaming. After scheduling a precache operation with the EGMapApi, this protocol can be used to query the progress of the operation, and to cancel the operation if required.
 */
@protocol EGPrecacheOperation<NSObject>

/*!
 @method cancel
 @brief Cancel a scheduled precache operation.
 @returns Returns nothing.
 */
- (void)cancel;

/*!
 @method cancelled
 @brief Test if the operation was cancelled.
 @returns YES if cancelled.
 */
- (BOOL)cancelled;

/*!
 @method completed
 @brief Test if the operation was completed.
 @returns YES if completed.
 */
- (BOOL)completed;

/*!
 @method percentComplete
 @brief Check the progress of the operation.
 @returns Percentage complete rounded to an int.
 */
- (int)percentComplete;

@end
