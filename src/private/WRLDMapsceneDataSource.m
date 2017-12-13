#include "WRLDMapsceneDataSource.h"

@interface WRLDMapsceneDataSource ()

@end

@implementation WRLDMapsceneDataSource
{
    
}

-initMapsceneDataSource:(NSString*)covarageTreeManifestUrl themeManifestUrl:(NSString*)themeManifestUrl
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
