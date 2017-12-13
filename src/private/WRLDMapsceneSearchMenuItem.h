#pragma once

#import <Foundation/Foundation.h>

@interface WRLDMapsceneSearchMenuItem:NSObject

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) NSString* tag;

@property (nonatomic, readonly) NSString* iconKey;

@property (nonatomic, readonly) bool skipYelpSearch;

-(instancetype)initMapsceneSearchMenuItem:(NSString*)name tag:(NSString*)tag iconKey:(NSString*)iconKey skipYelpSearch:(bool)skipYelpSearch;

@end
