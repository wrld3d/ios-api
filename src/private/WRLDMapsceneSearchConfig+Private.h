#pragma once

#import <Foundation/Foundation.h>
#import "WRLDMapsceneSearchConfig.h"

@class WRLDMapsceneSearchConfig;

@interface WRLDMapsceneSearchConfig(Private)


-(instancetype)initWithOutdoorSeachMenuItems:(NSArray <WRLDMapsceneSearchMenuItem *>*)outdoorSeachMenuItems
                       performStartupSearch:(bool)performStartupSearch
                          startupSearchTerm:(NSString*)startupSearchTerm
                   overrideIndoorSearchMenu:(bool)overrideIndoorSearchMenu;

@end

