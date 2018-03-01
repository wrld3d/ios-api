#pragma once

#import <UIKit/UIKit.h>

@class WRLDMenuGroup;
@class WRLDMenuChild;

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

- (WRLDMenuChild *)getChildAtIndex:(NSUInteger)index;

@end
