#pragma once

#import <Foundation/Foundation.h>

@interface WRLDMapsceneDataSource : NSObject

@property (nonatomic, readonly) NSString* covarageTreeManifestUrl;

@property (nonatomic, readonly) NSString* themeManifestUrl;

-initMapsceneDataSource:(NSString*)covarageTreeManifestUrl themeManifestUrl:(NSString*)themeManifestUrl;

@end
