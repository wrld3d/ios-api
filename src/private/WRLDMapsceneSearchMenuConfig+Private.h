#pragma once

#import <Foundation/Foundation.h>
#import  "WRLDMapsceneSearchMenuConfig.h"

@class WRLDMapsceneSearchMenuConfig;

@interface WRLDMapsceneSearchMenuConfig(Private)


-(instancetype)initWithOutdoorSeachMenuItems:(NSArray*)outdoorSeachMenuItems
                       performStartupSearch:(bool)performStartupSearch
                          startupSearchTerm:(NSString*)startupSearchTerm
                   overrideIndoorSearchMenu:(bool)overrideIndoorSearchMenu;

@end

