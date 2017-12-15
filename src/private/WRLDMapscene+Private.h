#pragma once

#include "WRLDMapscene.h"
#include <Foundation/Foundation.h>


@class WRLDMapsceneStartLocation;
@class WRLDMapsceneDataSource;
@class WRLDMapsceneSearchMenuConfig;
@class WRLDMapscene;

@interface WRLDMapscene (Private)

-(instancetype)initWithName:(NSString*)name
                  shortLink:(NSString*)shortLink
                     apiKey:(NSString*)apiKey
  wrldMapsceneStartLocation:(WRLDMapsceneStartLocation*)wrldMapsceneStartLocation
     wrldMapsceneDataSource:(WRLDMapsceneDataSource *)wrldMapsceneDataSource
wrldMapsceneSearchMenuConfig:(WRLDMapsceneSearchMenuConfig *)wrldMapsceneSearchMenuConfig;

@end

