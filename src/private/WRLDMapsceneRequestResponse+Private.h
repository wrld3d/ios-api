#pragma once

@class WRLDMapsceneRequestResponse;
@class WRLDMapscene;

#import "WRLDMapsceneRequestResponse.h"

@interface WRLDMapsceneRequestResponse (Private)

-(nullable instancetype)initWithSucceeded:(bool)succeeded mapscene:(nullable WRLDMapscene*)mapscene;

@end
