
#import "WRLDMapOptions.h"

@implementation WRLDMapOptions


+ (instancetype)mapOptions
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _coverageTreeManifest = @"";
        _environmentThemesManifest = @"";
    }
    return self;
}

- (void)setCoverageTreeManifest:(NSString *)coverageTreeManifest
{
    _coverageTreeManifest = coverageTreeManifest;
}

- (void)setEnvironmentThemesManifest:(NSString *)environmentThemesManifest
{
    _environmentThemesManifest = environmentThemesManifest;
}

@end
