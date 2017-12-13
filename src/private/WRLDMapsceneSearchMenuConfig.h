#pragma once

#import <Foundation/Foundation.h>

@interface WRLDMapsceneSearchMenuConfig:NSObject

@property (nonatomic, readonly) NSArray* outdoorSearchMenuItems;

@property (nonatomic, readonly) bool performStartupSearch;

@property (nonatomic, readonly) NSString* startupSearchTerm;

@property (nonatomic, readonly) bool overrideIndoorSearchMenu;

-(instancetype)initMapsceneSearchMenuConfig:(NSArray*)outdoorSeachMenuItems performStartupSearch:(bool)performStartupSearch startupSearchTerm:(NSString*)startupSearchTerm overrideIndoorSearchMenu:(bool)overrideIndoorSearchMenu;

@end
