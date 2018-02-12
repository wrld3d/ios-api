#pragma once

#include <UIKit/UIKit.h>

#include "WRLDSearchTypes.h"

@class WRLDSearchResultModel;

@protocol WRLDSearchResultsReadyDelegate
-(void) didComplete:(BOOL) success
        withResults:(WRLDSearchResultsCollection*) results;
@end
