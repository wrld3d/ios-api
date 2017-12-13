#include "WRLDMapscene.h"
#include "WRLDMapscene+Private.h"
#include "WRLDMapsceneStartLocation.h"
#include "WRLDMapsceneDataSource.h"

@interface WRLDMapscene()

@end

@implementation WRLDMapscene

-(void)setName:(NSString*)name
{
    _name = name;
}
-(void)setShortLink:(NSString*)shortLink
{
    _shortLinkUrl=shortLink;
}
-(void)setApiKey:(NSString*)apiKey
{
    _apiKey=apiKey;
}
-(void)setWRLDMapsceneStartLocation:(WRLDMapsceneStartLocation*)wrldMapsceneStartLocation
{
    _wrldMapsceneStartLocation = wrldMapsceneStartLocation;
}

-(void)setWRLDMapsceneDataSource:(WRLDMapsceneDataSource *)wrldMapsceneDataSource
{
    _wrldMapsceneDataSource = wrldMapsceneDataSource;
}

-(void)setWRLDMapsceneSearchMenuConfig:(WRLDMapsceneSearchMenuConfig *)wrldMapsceneSearchMenuConfig
{
    _wrldMapsceneSearchMenuConfig = wrldMapsceneSearchMenuConfig;
}

@end
