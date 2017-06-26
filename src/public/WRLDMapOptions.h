#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// Map options specifies a configuration for creating a <WRLDMapView>.
@interface WRLDMapOptions : NSObject

/*!
 Initialize an instance of WLRDMapOptions with the default options.
 
 @returns A WRLDMapOptions instance.
 */
+ (instancetype)mapOptions;

/// The coverage tree manifest url for the map.
@property (nonatomic, copy) NSString* coverageTreeManifest;

/// The environment themes manifest url for the map.
@property (nonatomic, copy) NSString* environmentThemesManifest;

@end

NS_ASSUME_NONNULL_END
