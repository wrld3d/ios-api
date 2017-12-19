#pragma once

#include "WRLDMapscene.h"
#include <Foundation/Foundation.h>


@class WRLDMapsceneStartLocation;
@class WRLDMapsceneDataSources;
@class WRLDMapsceneSearchConfig;
@class WRLDMapscene;

@interface WRLDMapscene (Private)

-(instancetype)initWithName:(NSString*)name
                  shortLink:(NSString*)shortLink
                     apiKey:(NSString*)apiKey
              startLocation:(WRLDMapsceneStartLocation*)startLocation
                dataSources:(WRLDMapsceneDataSources *)dataSources
               searchConfig:(WRLDMapsceneSearchConfig *)searchConfig;

@end

