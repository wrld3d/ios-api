#pragma once

#import <Foundation/Foundation.h>

@class WRLDSearchRequest;

@protocol WRLDSearchProvider
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *cellIdentifier;
- (void) searchFor: (WRLDSearchRequest *) query;

@end
