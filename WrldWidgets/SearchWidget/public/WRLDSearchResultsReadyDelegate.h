#pragma once

#include <UIKit/UIKit.h>

@class WRLDSearchResultModel;

@protocol WRLDSearchResultsReadyDelegate
-(void) searchDidComplete:(BOOL) success
              withResults:(NSArray<WRLDSearchResultModel *>*) results;
@end
