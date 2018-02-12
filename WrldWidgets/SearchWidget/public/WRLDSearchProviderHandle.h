#pragma once

#import <UIKit/UIKit.h>
#import "WRLDQueryFulfillerHandle.h"

@protocol WRLDSearchProvider;

@interface WRLDSearchProviderHandle : NSObject<WRLDQueryFulfillerHandle>
@property (readonly) id<WRLDSearchProvider> provider;
@end
