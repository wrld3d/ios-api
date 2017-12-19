#pragma once

#import <Foundation/Foundation.h>

#include "WRLDMapsceneDataSources.h"

@class WRLDMapsceneDataSources;

@interface WRLDMapsceneDataSources (Private)

-initWithCovarageTreeManifestUrl:(NSString*)covarageTreeManifestUrl themeManifestUrl:(NSString*)themeManifestUrl;

@end

