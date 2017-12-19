#include "WRLDMapsceneDataSources.h"

@interface WRLDMapsceneDataSources ()

@end

@implementation WRLDMapsceneDataSources
{
    
}

-initWithCovarageTreeManifestUrl:(NSString*)covarageTreeManifestUrl themeManifestUrl:(NSString*)themeManifestUrl
{
    self = [super init];
    
    if(self)
    {
        _covarageTreeManifestUrl = covarageTreeManifestUrl;
        _themeManifestUrl = themeManifestUrl;
    }
    
    return self;
}

@end
