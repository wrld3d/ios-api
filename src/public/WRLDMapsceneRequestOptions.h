#pragma once

#import <Foundation/Foundation.h>

@interface WRLDMapsceneRequestOptions : NSObject

-(instancetype)initMapsceneRequestOptions :(NSString*)shortLinkUrl :(bool)applyMapsceneOnSuccess;

-(NSString*)getShortLinkUrl;

-(bool)getApplyMapsceneOnSuccess;

@end
