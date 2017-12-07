#pragma once

#include "EegeoMapsceneApi.h"
#include "WRLDMapsceneService.h"

@class WRLDMapsceneService;

@interface WRLDMapsceneService (Private)

- (instancetype)initWithApi:(Eegeo::Api::EegeoMapsceneApi&)mapsceneApi;

@end

