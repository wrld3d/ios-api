#import <Foundation/Foundation.h>

#import "WRLDMapsceneSearchConfig.h"
#import "WRLDMapsceneSearchConfig+Private.h"

@interface WRLDMapsceneSearchConfig()

@end

@implementation WRLDMapsceneSearchConfig

-(instancetype)initWithOutdoorSeachMenuItems:(NSArray <WRLDMapsceneSearchMenuItem *>*)outdoorSeachMenuItems
                        performStartupSearch:(bool)performStartupSearch
                           startupSearchTerm:(NSString*)startupSearchTerm
                    overrideIndoorSearchMenu:(bool)overrideIndoorSearchMenu
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
