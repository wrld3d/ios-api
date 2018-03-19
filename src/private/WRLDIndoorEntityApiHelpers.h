#pragma once

#import <Foundation/Foundation.h>

#import "WRLDIndoorEntityTapResult.h"

#include "EegeoIndoorEntityApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDIndoorEntityApiHelpers : NSObject

+ (WRLDIndoorEntityTapResult*) createIndoorEntityTapResult:(const Eegeo::Api::IndoorEntityPickedMessage&) withIndoorEntityPickedMessage
                                               indoorMapId:(NSString*)indoorMapId;

@end

NS_ASSUME_NONNULL_END
