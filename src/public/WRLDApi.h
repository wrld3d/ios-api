#import <Foundation/Foundation.h>

/*!
 Exposes a method to get this map's API key.
 The API key for a map should be set in your app's `info.plist` file.
 */
@interface WRLDApi : NSObject

/// @returns The API key used by this map.
+ (nullable NSString *)apiKey;

@end
