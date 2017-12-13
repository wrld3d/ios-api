#pragma once

#import <Foundation/Foundation.h>
#import "WRLDMapscene.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 * A response to the mapscene Request. This is returned when a mapscene request completes via a callback.
 */
@interface WRLDMapsceneRequestResponse : NSObject

/*!
 * @return True if the request was successful, else false.
 */
-(bool)getSucceeded;

/*!
 * Gets the requested mapscene.
 * @return The requested mapscene.
 */
-(WRLDMapscene*)getMapscene;

@end

NS_ASSUME_NONNULL_END
