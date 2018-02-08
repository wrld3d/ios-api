#pragma once

#import <Foundation/Foundation.h>

@class WRLDSearchQuery;
@protocol WRLDSearchProvider
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *cellIdentifier;
- (void) search: (WRLDSearchQuery *) query;

@end
