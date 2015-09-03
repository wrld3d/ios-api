// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EGPrecacheOperation.h"
#import "EGInternalApi.h"
#import "EGMapDelegate.h"
#include "Web.h"
#include "VectorMath.h"

@interface EGPrecacheOperationImplementation : NSObject<EGPrecacheOperation>

- (id)initWithPrecacheService:(Eegeo::Web::PrecacheService&)precacheService
                    scheduler:(Eegeo::Api::PrecacheOperationScheduler&)precacheOperationScheduler
                       center:(const Eegeo::dv3&)ecefCentre
                       radius:(double)radius
                     delegate:(id<EGMapDelegate>)delegate;

- (BOOL)tryStart;

- (BOOL)inFlight;

- (void)update;

@end
