#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDPoiSearchResponse : NSObject

@property (nonatomic) BOOL succeeded;

@property (nonatomic) NSMutableArray* results;

@end

NS_ASSUME_NONNULL_END
