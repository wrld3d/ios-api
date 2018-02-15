#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchTypes.h"

@class WRLDSearchQuery;
@protocol WRLDSearchRequestFulfillerHandle;
@protocol WRLDSearchResultModel;

@interface WRLDSearchWidgetResultSetViewModel : NSObject

typedef NS_ENUM(NSInteger, ExpandedStateType) {
    Hidden,
    Collapsed,
    Expanded
};

@property (nonatomic, readonly) NSInteger fulfillerId;
@property (nonatomic, readonly) ExpandedStateType expandedState;
@property (nonatomic, readonly) NSInteger totalResultCount;
@property (nonatomic, readonly) CGFloat expectedCellHeight;
@property (nonatomic, readonly) BOOL hasMoreToShow;

- (instancetype) initForRequestFulfiller: (id<WRLDSearchRequestFulfillerHandle>) requestFulfillerHandle;
- (void) updateResultData: (WRLDSearchResultsCollection *) results;

- (id<WRLDSearchResultModel>) getResult: (NSInteger) index;

- (NSInteger) getVisibleResultCount;

@end



