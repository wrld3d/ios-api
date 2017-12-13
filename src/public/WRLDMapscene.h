#pragma once

#include <Foundation/Foundation.h>

@class WRLDMapsceneStartLocation;
@class WRLDMapsceneDataSource;
@class WRLDMapsceneSearchMenuConfig;

/*!
 * The data that defines a mapscene, as created by the Map Designer or the mapscene REST Api.
 */
@interface WRLDMapscene: NSObject

/*!
 * @returns The name of the mapcene.
 */
@property (readonly) NSString* name;

/*!
 * @returns The shortend URL of the mapscene.
 */
@property (readonly) NSString* shortLinkUrl;

/*!
 * @returns The API key to use for authenticating with the WRLD SDK. This is also used to link
 * associated POI sets for use with the Searchbox Widget and POI Api.
 */
@property (readonly) NSString* apiKey;

/*!
 * @returns The initial start location of the mapscene.
 */
@property (readonly) WRLDMapsceneStartLocation* wrldMapsceneStartLocation;

@property (readonly) WRLDMapsceneDataSource* wrldMapsceneDataSource;

@property (readonly) WRLDMapsceneSearchMenuConfig* wrldMapsceneSearchMenuConfig;

@end
