#pragma once
#include "WRLDMapsceneRequest.h"
#include "WRLDMapsceneRequestOptions.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * A service which allows you to request Mapscenes, as created by the WRLD Map Designer.
 * Created by the createMapsceneService method of the EegeoMap object.
 *
 * This is a Java interface to the WRLD MAPSCENE REST API (https://github.com/wrld3d/wrld-mapscene-api).
 *
 * It also supports additional options for applying a Mapscene to a map when you successfully load it.
 */
@interface WRLDMapsceneService : NSObject

/*!
 * Begins a Mapscene request with the given options. The results will be passed via the WRLDMapViewDelegate
 * mapsceneRequestDidComplete method.
 * @param mapsceneRequestOptions The paramaters of the request.
 * @return An instance of a WRLDMapsceneRequest. This can be used to cancel the request before it is completed.
 */
-(WRLDMapsceneRequest*)requestMapscene :(WRLDMapsceneRequestOptions*)mapsceneRequestOptions;

@end

NS_ASSUME_NONNULL_END
