#pragma once

#include "WRLDSearchWidgetObserver.h"

@interface WRLDSearchWidgetObserver (Private)

- (void)searchbarGainFocus;

- (void)searchbarResignFocus;

- (void)searchWidgetGainFocus;

- (void)searchWidgetResignFocus;

- (void)receiveSearchResults;

- (void)clearSearchResults;

- (void)showSearchResults;

- (void)hideSearchResults;

@end

