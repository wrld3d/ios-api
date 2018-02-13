#pragma once

#import "WRLDQueryStartingDelegate.h"
#import "WRLDQueryFinishedDelegate.h"

@protocol WRLDQueryFulfillerHandle;
@class WRLDMultipleProviderQuery;

@interface WRLDSearchModelQueryDelegate : NSObject<WRLDQueryStartingDelegate, WRLDQueryFinishedDelegate>

- (void) addQueryStartingDelegate :(id<WRLDQueryStartingDelegate>) queryStartedDelegate;
- (void) removeQueryStartingDelegate :(id<WRLDQueryStartingDelegate>) queryStartedDelegate;

- (void) addQueryCompletedDelegate :(id<WRLDQueryFinishedDelegate>) queryFinishedDelegate;
- (void) removeQueryCompletedDelegate :(id<WRLDQueryFinishedDelegate>) queryFinishedDelegate;

@end

