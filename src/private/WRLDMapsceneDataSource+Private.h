#pragma once

#import <Foundation/Foundation.h>

#include "WRLDMapsceneDataSource.h"

@class WRLDMapsceneDataSource;

@interface WRLDMapsceneDataSource (Private)

-initWithCovarageTreeManifestUrl:(NSString*)covarageTreeManifestUrl themeManifestUrl:(NSString*)themeManifestUrl;

@end

