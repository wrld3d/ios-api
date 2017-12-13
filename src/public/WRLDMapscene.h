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
-(NSString*)getName;

/*!
 * @returns The shortend URL of the mapscene.
 */
-(NSString*)getShortLink;

/*!
 * @returns The API key to use for authenticating with the WRLD SDK. This is also used to link
 * associated POI sets for use with the Searchbox Widget and POI Api.
 */
-(NSString*)getApiKey;

/*!
 * @returns The initial start location of the mapscene.
 */
-(WRLDMapsceneStartLocation*)getWRLDMapsceneStartLocation;

-(WRLDMapsceneDataSource*)getWRLDMapsceneDataSource;

-(WRLDMapsceneSearchMenuConfig*)getWRLDMapsceneSearchMenuConfig;

@end
