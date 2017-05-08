#pragma once

#import <Foundation/Foundation.h>

@interface WRLDIndoorMapFloor: NSObject

@property (readonly) NSString* floorId;
@property (readonly) NSString* name;
@property (readonly) int floorIndex;

- (id) initWithId: (NSString*)floorId name: (NSString*)name floorIndex:(int)floorIndex;

@end


@interface WRLDIndoorMap: NSObject

@property (readonly) NSString* indoorId;
@property (readonly) NSString* name;
@property (readonly) NSArray<WRLDIndoorMapFloor*>* floors;
@property (readonly) NSString* userData;

- (id) initWithId: (NSString*)indoorId name: (NSString*)name floors: (NSArray<WRLDIndoorMapFloor*>*)floors userData: (NSString*)userData;

@end
