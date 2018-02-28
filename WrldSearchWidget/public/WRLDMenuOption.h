#pragma once

#import <Foundation/Foundation.h>

@class WRLDMenuChild;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMenuOption : NSObject

@property (nonatomic, copy) NSString* text;

@property (nonatomic, copy) NSObject* context;

- (instancetype)initWithText:(NSString *)text
                     context:(nullable NSObject *)context;

- (bool)hasChildren;

- (NSMutableArray *)getChildren;

- (void)addChild:(WRLDMenuChild *)child;

- (void)addChild:(NSString *)text
            icon:(NSString *)icon
         context:(NSObject *)context;

@end

NS_ASSUME_NONNULL_END

