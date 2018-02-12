#pragma once

#import <Foundation/Foundation.h>

@class WRLDSearchQuery;
@protocol WRLDSearchResultsReadyDelegate;

@protocol WRLDSearchProvider
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *cellIdentifier;
- (void) searchFor: (WRLDSearchQuery *) query;

@end
