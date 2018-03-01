#pragma once

#import <Foundation/Foundation.h>

#include <vector>
#include <string>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDStringApiHelpers : NSObject

+ (std::vector<std::string>) copyToStringVector:(NSArray<NSString*>*) fromNSArray;
+ (NSArray<NSString*>*) copyToNSStringArray:(const std::vector<std::string>&) fromStringVector;

@end

NS_ASSUME_NONNULL_END
