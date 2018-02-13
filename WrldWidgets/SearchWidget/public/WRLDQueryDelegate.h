
#pragma once

#include <Foundation/Foundation.h>

#include "WRLDSearchTypes.h"

@class WRLDSearchQuery;

@interface WRLDQueryDelegate : NSObject
-(void) aboutToSend:(WRLDSearchQuery *) query;
-(void) completed:(WRLDSearchQuery *) query;
@end
