#pragma once

#include <Foundation/Foundation.h>

@class WRLDMapsceneStartLocation;

/*!
 * The data that defines a Mapscene, as created by the Map Designer or the Mapscene REST Api.
 */
@interface WRLDMapscene: NSObject

/*!
 * @returns The name of the Mapcene.
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
 * @returns The initial start location of the Mapscene.
 */
-(WRLDMapsceneStartLocation*)getWRLDMapsceneStartLocation;

@end
