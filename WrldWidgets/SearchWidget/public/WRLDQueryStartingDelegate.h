#pragma once

#include <UIKit/UIKit.h>

@class WRLDSearchQuery;

@protocol WRLDQueryStartingDelegate
-(void) willSearchFor: (WRLDSearchQuery*) query;
@end

