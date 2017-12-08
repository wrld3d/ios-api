#pragma once

#include "WRLDMapsceneRequestResponse.h"

@class WRLDMapsceneRequestResponse;

@interface WRLDMapsceneRequestResponse (Private)

-(instancetype)initMapsceneRequestResponse :(bool)succeeded :(WRLDMapscene*)mapscene;

@end
