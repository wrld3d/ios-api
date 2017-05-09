#pragma once

#import <Foundation/Foundation.h>

@interface WRLDIndoorMapFloor: NSObject

@property (readonly) NSString* floorId;
@property (readonly) NSString* name;
@property (readonly) int floorIndex;

@end


@interface WRLDIndoorMap: NSObject

@property (readonly) NSString* indoorId;
@property (readonly) NSString* name;
@property (readonly) NSArray<WRLDIndoorMapFloor*>* floors;
@property (readonly) NSString* userData;

@end
