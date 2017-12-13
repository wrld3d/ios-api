#pragma once
#include "WRLDMapsceneRequest.h"
#include "WRLDMapsceneRequestOptions.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * A service which allows you to load a Mapscene from a shortlink.  the map designer tools.
 */
@interface WRLDMapsceneService : NSObject

/*!
 * Begins a Mapscene request with the given options.
 * @param mapsceneRequestOptions The paramaters of the request.
 * @return An instance of a MapsceneRequest. This can be used to cancel the request before it is completed.
 */
-(WRLDMapsceneRequest*)RequestMapscene :(WRLDMapsceneRequestOptions*)mapsceneRequestOptions;

@end

NS_ASSUME_NONNULL_END
