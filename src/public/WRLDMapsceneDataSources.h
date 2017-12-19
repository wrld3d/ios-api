#pragma once

#import <Foundation/Foundation.h>

/**
 * The data defining the source manifest files to load for a given Mapscene.  This defines what
 * data is loaded and what theme to apply.
 */
@interface WRLDMapsceneDataSources : NSObject

/**
 * The coverage tree manifest to load for this Mapscene.
 */
@property (nonatomic, readonly) NSString* covarageTreeManifestUrl;

/**
 * The themes manifest to load for this Mapscene.
 */
@property (nonatomic, readonly) NSString* themeManifestUrl;


@end


