#include "WRLDMapscene.h"
#include "WRLDMapscene+Private.h"
#include "WRLDMapsceneStartLocation.h"
#include "WRLDMapsceneDataSource.h"

@interface WRLDMapscene()

@end

@implementation WRLDMapscene

-(instancetype)initWithName:(NSString*)name
                  shortLink:(NSString*)shortLink
                     apiKey:(NSString*)apiKey
  wrldMapsceneStartLocation:(WRLDMapsceneStartLocation*)wrldMapsceneStartLocation
     wrldMapsceneDataSource:(WRLDMapsceneDataSource *)wrldMapsceneDataSource
wrldMapsceneSearchMenuConfig:(WRLDMapsceneSearchMenuConfig *)wrldMapsceneSearchMenuConfig
{
    
    self = [super init];
    
    if(self)
    {
        _name = name;
        _shortLinkUrl=shortLink;
        _apiKey=apiKey;
        _wrldMapsceneStartLocation = wrldMapsceneStartLocation;
        _wrldMapsceneDataSource = wrldMapsceneDataSource;
        _wrldMapsceneSearchMenuConfig = wrldMapsceneSearchMenuConfig;
    }
    
    return self;
    
}


@end
