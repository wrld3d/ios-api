#pragma once

#import <UIKit/UIKit.h>

@class WRLDMenuGroup;
@class WRLDMenuChild;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMenuTableSectionViewModel : NSObject

typedef NS_ENUM(NSInteger, ExpandedStateType)
{
    Collapsed,
    Expanded
};

@property (nonatomic, readonly) ExpandedStateType expandedState;

- (instancetype)initWithMenuGroup:(WRLDMenuGroup *)menuGroup;

- (instancetype)initWithMenuGroup:(WRLDMenuGroup *)menuGroup
                      optionIndex:(NSUInteger)optionIndex;

- (bool)isTitleSection;

- (bool)isFirstOptionInGroup;

- (bool)isLastOptionInGroup;

- (bool)isExpandable;

- (void)setExpandedState:(ExpandedStateType)state;

- (NSString *)getText;

- (NSInteger)getChildCount;

- (nullable WRLDMenuChild *)getChildAtIndex:(NSUInteger)index;

- (nullable NSObject *)getContext;

- (nullable NSObject *)getChildContextAtIndex:(NSUInteger)index;

- (CGFloat)getViewHeight;

- (CGFloat)getChildViewHeight;

NS_ASSUME_NONNULL_END

@end
