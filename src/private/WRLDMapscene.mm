#include "WRLDMapscene.h"
#include "WRLDMapscene+Private.h"
#include "WRLDMapsceneStartLocation.h"
#include "WRLDMapsceneDataSources.h"

@interface WRLDMapscene()

@end

@implementation WRLDMapscene

-(instancetype)initWithName:(NSString*)name
                  shortLink:(NSString*)shortLink
                     apiKey:(NSString*)apiKey
              startLocation:(WRLDMapsceneStartLocation*)startLocation
                dataSources:(WRLDMapsceneDataSources *)dataSources
               searchConfig:(WRLDMapsceneSearchConfig *)searchConfig
{
    
    self = [super init];
    
    if(self)
    {
        _name = name;
        _shortLinkUrl=shortLink;
        _apiKey=apiKey;
        _startLocation = startLocation;
        _dataSources = dataSources;
        _searchConfig = searchConfig;
    }
    
    return self;
    
}


@end
