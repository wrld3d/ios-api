#pragma once

#include "WRLDMapscene.h"
#include <Foundation/Foundation.h>


@class WRLDMapsceneStartLocation;
@class WRLDMapsceneDataSource;
@class WRLDMapsceneSearchMenuConfig;
@class WRLDMapscene;

@interface WRLDMapscene (Private)

-(void)setName:(NSString*)name;
-(void)setShortLink:(NSString*)shortLink;
-(void)setApiKey:(NSString*)apiKey;
-(void)setWRLDMapsceneStartLocation:(WRLDMapsceneStartLocation*)wrldCoordinateWithAltitude;
-(void)setWRLDMapsceneDataSource:(WRLDMapsceneDataSource *)wrldMapsceneDataSource;
-(void)setWRLDMapsceneSearchMenuConfig:(WRLDMapsceneSearchMenuConfig *)wrldMapsceneSearchMenuConfig;

@end

