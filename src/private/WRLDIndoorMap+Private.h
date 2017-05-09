#pragma once

NS_ASSUME_NONNULL_BEGIN

@class WRLDIndoorMapFloor;

@interface WRLDIndoorMap (Private)

- (id) initWithId: (NSString*)indoorId name: (NSString*)name floors: (NSArray<WRLDIndoorMapFloor*>*)floors userData: (NSString*)userData;

@end

@interface WRLDIndoorMapFloor (Private)

- (id) initWithId: (NSString*)floorId name: (NSString*)name floorIndex:(NSInteger)floorIndex;

@end

NS_ASSUME_NONNULL_END
