#pragma once

#import "WRLDMapsceneService.h"

#include "EegeoMapsceneApi.h"

@class WRLDMapsceneService;

@interface WRLDMapsceneService (Private)

- (instancetype)initWithApi:(Eegeo::Api::EegeoMapsceneApi&)mapsceneApi;

@end

