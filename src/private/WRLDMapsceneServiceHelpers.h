#pragma once

#include "MapsceneRequestResponse.h"

@class WRLDMapsceneRequestResponse;
@class WRLDMapscene;
@class WRLDMapsceneStartLocation;
@class WRLDMapsceneDataSources;
@class WRLDMapsceneSearchConfig;
@class WRLDMapsceneSearchMenuItem;

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapsceneServiceHelpers : NSObject

+ (WRLDMapsceneRequestResponse*)createWRLDMapsceneRequestResponse:(const Eegeo::Mapscenes::MapsceneRequestResponse&)withResponse;

+ (WRLDMapscene*)createWRLDMapscene:(const Eegeo::Mapscenes::Mapscene&)withMapscene;

+ (WRLDMapsceneDataSources*)createWRLDMapsceneDataSources:(const Eegeo::Mapscenes::MapsceneDataSources&)withDataSources;

+ (WRLDMapsceneStartLocation*)createWRLDMapsceneStartLocation:(const Eegeo::Mapscenes::MapsceneStartLocation&)withStartLocation;

+ (WRLDMapsceneSearchConfig*)createWRLDMapsceneSearchConfig:(const Eegeo::Mapscenes::MapsceneSearchConfig&)withSearchConfig;

+ (WRLDMapsceneSearchMenuItem*)createWRLDMapsceneSearchMenuItem:(const Eegeo::Mapscenes::MapsceneSearchMenuItem&)withSearchMenuItem;
@end



NS_ASSUME_NONNULL_END
