#pragma once

#include "EegeoMapsceneApi.h"
#include "WRLDMapsceneRequest.h"
#include "WRLDMapsceneRequestOptions.h"

@class WRLDMapsceneRequest;

@interface WRLDMapsceneRequest (Private)

- (instancetype)initWithMapsceneApi:(Eegeo::Api::EegeoMapsceneApi*)mapsceneApi :(WRLDMapsceneRequestOptions *)mapsceneRequestOptions;

@end
