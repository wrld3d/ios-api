//
//  WRLDMapsceneSearchMenuConfig.m
//  WrldSdk
//
//  Created by Sam Ainsworth on 12/12/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WRLDMapsceneSearchMenuConfig.h"
#import "WRLDMapsceneSearchMenuConfig+Private.h"

@interface WRLDMapsceneSearchMenuConfig()

@end

@implementation WRLDMapsceneSearchMenuConfig

-(instancetype)initWithOutdoorSeachMenuItems:(NSArray*)outdoorSeachMenuItems performStartupSearch:(bool)performStartupSearch startupSearchTerm:(NSString*)startupSearchTerm overrideIndoorSearchMenu:(bool)overrideIndoorSearchMenu
{
    self = [super init];
    
    if(self)
    {
        _outdoorSearchMenuItems = outdoorSeachMenuItems;
        _performStartupSearch = performStartupSearch;
        _startupSearchTerm = startupSearchTerm;
        _overrideIndoorSearchMenu = overrideIndoorSearchMenu;
    }
    
    return self;
}

@end
