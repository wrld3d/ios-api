#pragma once

#import <Foundation/Foundation.h>
#import "WRLDMapscene.h"

@interface WRLDMapsceneRequestResponse : NSObject

-(bool)getSucceeded;

-(instancetype)initMapsceneRequestResponse :(bool)succeeded :(WRLDMapscene*)mapscene;

@end
