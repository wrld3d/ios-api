#pragma once

#import <Foundation/Foundation.h>
#import "WRLDPrecacheOperationResult.h"

#include "EegeoPrecacheApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDPrecacheOperation;

@interface WRLDPrecacheOperation (Private)
- (instancetype)initWithId:(int)operationId
               precacheApi:(Eegeo::Api::EegeoPrecacheApi&)precacheApi
         completionHandler:(WRLDPrecacheOperationHandler)completionHandler;

- (void)completeWithResult:(WRLDPrecacheOperationResult*)response;
@end

NS_ASSUME_NONNULL_END
