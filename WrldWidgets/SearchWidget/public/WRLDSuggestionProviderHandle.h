#pragma once

#import <UIKit/UIKit.h>
#import "WRLDQueryFulfillerHandle.h"

@protocol WRLDSuggestionProvider;

@interface WRLDSuggestionProviderHandle : NSObject<WRLDQueryFulfillerHandle>
@property (readonly) id<WRLDSuggestionProvider>  provider;
@end
