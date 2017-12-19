#pragma once

#import "WRLDMapsceneSearchMenuItem.h"
#import <Foundation/Foundation.h>

@class WRLDMapsceneSearchMenuItem;

@interface WRLDMapsceneSearchMenuItem (Private)
{
    
}

-(instancetype)initWithName:(NSString*)name tag:(NSString*)tag iconKey:(NSString*)iconKey skipYelpSearch:(bool)skipYelpSearch;

@end

