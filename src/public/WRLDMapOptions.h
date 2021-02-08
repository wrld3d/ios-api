#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// Map options specifies a configuration for creating a <WRLDMapView>.
@interface WRLDMapOptions : NSObject

/*!
 Instantiate an instance of WLRDMapOptions with default options.
 
 @returns A WRLDMapOptions instance.
 */
+ (instancetype)mapOptions;

/*!
  The coverage tree manifest url for the map.  By default, the map will
  load the latest public manifest which is updated regularly.
*/
@property (nonatomic, copy) NSString* coverageTreeManifest;

/*!
  The environment themes manifest url for the map.  By default, the map will
  load the latest themes manifest which is updated regularly.
*/
@property (nonatomic, copy) NSString* environmentThemesManifest;

@end

NS_ASSUME_NONNULL_END
