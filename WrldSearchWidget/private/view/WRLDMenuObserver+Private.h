#pragma once

#include "WRLDMenuObserver.h"

@interface WRLDMenuObserver (Private)

- (void)selected:(NSObject *)optionContext;

- (void)expanded:(NSObject *)optionContext
 fromInteraction:(BOOL)fromInteraction;

- (void)collapsed:(NSObject *)optionContext
  fromInteraction:(BOOL)fromInteraction;

@end
