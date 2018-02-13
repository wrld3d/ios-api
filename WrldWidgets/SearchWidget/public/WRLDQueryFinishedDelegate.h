#pragma once

#include <UIKit/UIKit.h>

@class WRLDSearchQuery;

@protocol WRLDQueryFinishedDelegate
-(void) didComplete: (WRLDSearchQuery*) query;
@end
