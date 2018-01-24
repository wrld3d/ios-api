#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchQuery;

@protocol WRLDSearchDelegate
-(void) doSearch :(WRLDSearchQuery*) query;
@end


