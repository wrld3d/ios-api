#pragma once

#import <Foundation/Foundation.h>
#import "WRLDMapscene.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 * A response to the Mapscene Request. This is returned when a mapscene request completes via a callback.
 */
@interface WRLDMapsceneRequestResponse : NSObject

/*!
 * @return true if the request was successful, else false.
 */
-(bool)getSucceeded;

/*!
 * Gets the requested Mapscene.
 * @return The requested Mapscene.
 */
-(WRLDMapscene*)getMapscene;

@end

NS_ASSUME_NONNULL_END
