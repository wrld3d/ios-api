#pragma once

#include <Foundation/Foundation.h>

@class WRLDMapsceneStartLocation;
@class WRLDMapsceneDataSources;
@class WRLDMapsceneSearchConfig;

/*!
 * The data that defines a mapscene, as created by the Map Designer or the mapscene REST Api.
 */
@interface WRLDMapscene: NSObject

/// The name of this mapcene.
@property (readonly) NSString* name;

/// The shortend URL of the mapscene.
@property (readonly) NSString* shortLinkUrl;

/// The API key to use for authenticating with the WRLD SDK. This is also used to link associated POI sets for use with the Searchbox Widget and POI Api.
@property (readonly) NSString* apiKey;

/// The initial start location of the mapscene.
@property (readonly) WRLDMapsceneStartLocation* startLocation;

/// The configuration of the data and themes to load for this mapscene.
@property (readonly) WRLDMapsceneDataSources* dataSources;

/// Optional configuration of the Searchbox Widget for this mapscene.
@property (readonly) WRLDMapsceneSearchConfig* searchConfig;

@end
