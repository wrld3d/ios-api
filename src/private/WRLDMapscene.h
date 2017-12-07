#pragma once

#include <Foundation/Foundation.h>

@class WRLDMapsceneStartLocation;

@interface WRLDMapscene: NSObject

-(id)initWRLDMapscene:(NSString*)name
                     :(NSString*)shortLink
                     :(NSString*)apiKey
                     :(WRLDMapsceneStartLocation*)wrldMapsceneStartLocation;

-(NSString*)getName;
-(NSString*)getShortLink;
-(NSString*)getApiKey;
-(WRLDMapsceneStartLocation*)getWRLDMapsceneStartLocation;

-(void)setName:(NSString*)name;
-(void)setShortLink:(NSString*)shortLink;
-(void)setApiKey:(NSString*)apiKey;
-(void)setWRLDMapsceneStartLocation:(WRLDMapsceneStartLocation*)wrldCoordinateWithAltitude;

@end
