#pragma once

#include <Foundation/Foundation.h>

@class WRLDMapsceneStartLocation;

@interface WRLDMapscene: NSObject

-(NSString*)getName;
-(NSString*)getShortLink;
-(NSString*)getApiKey;
-(WRLDMapsceneStartLocation*)getWRLDMapsceneStartLocation;


@end
