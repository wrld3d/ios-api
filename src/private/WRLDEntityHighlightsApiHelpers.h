#pragma once

#import <Foundation/Foundation.h>

#include <vector>
#include <string>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDEntityHighlightsApiHelpers : NSObject

+ (std::vector<std::string>) createNativeEntityHighlightIds:(NSArray<NSString*>*) withHightlightIds;
+ (NSArray<NSString*>*) createEntityHighlightIds:(const std::vector<std::string>&) withHightlightIds;

@end

NS_ASSUME_NONNULL_END
