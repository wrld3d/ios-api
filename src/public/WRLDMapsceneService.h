#pragma once
#include "WRLDMapsceneRequest.h"
#include "WRLDMapsceneRequestOptions.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 A service which allows you to load Mapscene from a shortlink from the map designer tools.
 */
@interface WRLDMapsceneService : NSObject

-(WRLDMapsceneRequest*)RequestMapscene :(WRLDMapsceneRequestOptions*)mapsceneRequestOptions;

@end

NS_ASSUME_NONNULL_END
