#pragma once

#import <Foundation/Foundation.h>
#import "WRLDMapscene.h"

NS_ASSUME_NONNULL_BEGIN
@interface WRLDMapsceneRequestResponse : NSObject

-(bool)getSucceeded;

-(WRLDMapscene*)getMapscene;

@end

NS_ASSUME_NONNULL_END
