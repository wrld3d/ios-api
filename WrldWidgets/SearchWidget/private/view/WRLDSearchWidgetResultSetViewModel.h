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
@property (nonatomic, readonly) CGFloat expectedCellHeight;
@property (nonatomic, readonly, copy) NSString* cellIdentifier;
@property (nonatomic, readonly, copy) NSString* moreResultsName;

- (instancetype) initForRequestFulfiller: (id<WRLDSearchRequestFulfillerHandle>) requestFulfillerHandle
                  maxToShowWhenCollapsed: (NSInteger) maxToShowWhenCollapsed
                   maxToShowWhenExpanded: (NSInteger) maxToShoWhenExpanded;

- (void) updateResultData: (WRLDSearchResultsCollection *) results;
- (void) setExpandedState: (ExpandedStateType) state;

- (CGFloat) getResultsCellHeightWhen: (ExpandedStateType) expandedState;
- (NSInteger) getVisibleResultCountWhen: (ExpandedStateType) expandedState;
- (BOOL) hasMoreResultsCellWhen: (ExpandedStateType) expandedState;

- (id<WRLDSearchResultModel>) getResult: (NSInteger) index;
- (NSInteger) getResultCount;
- (BOOL) isMoreResultsCell: (NSInteger) row;

@end



