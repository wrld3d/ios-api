#pragma once

#include <vector>

#include "EegeoPickingApi.h"

#import <Foundation/Foundation.h>

#import "WRLDPickResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDPickingApiHelpers : NSObject

+ (WRLDPickResult*) createWRLDPickResult:(const Eegeo::Api::PickResult&) withPickResult;

@end

NS_ASSUME_NONNULL_END
