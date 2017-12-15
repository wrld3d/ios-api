#pragma once

#include "WRLDMapsceneRequestResponse.h"

@class WRLDMapsceneRequestResponse;

@interface WRLDMapsceneRequestResponse (Private)

-(instancetype)initWithSucceeded:(bool)succeeded mapscene:(WRLDMapscene*)mapscene;

@end
