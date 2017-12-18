#pragma once

#import "WRLDMapsceneRequest.h"
#import "WRLDMapsceneRequestOptions.h"

#include "EegeoMapsceneApi.h"

@class WRLDMapsceneRequest;

@interface WRLDMapsceneRequest (Private)

- (instancetype)initWithMapsceneApi:(Eegeo::Api::EegeoMapsceneApi*)mapsceneApi :(WRLDMapsceneRequestOptions *)mapsceneRequestOptions;

@end
