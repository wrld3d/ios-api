#pragma once

#import "WRLDBuildingHighlightOptions.h"
#import "WRLDBuildingHighlightSelectionMode.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingHighlightOptions;

@interface WRLDBuildingHighlightOptions (Private)

- (instancetype) initWithLocation2:(CLLocationCoordinate2D)location;

- (instancetype) initWithScreenPoint:(CGPoint)screenPoint;

- (WRLDBuildingHighlightSelectionMode) selectionMode;

- (CLLocationCoordinate2D) selectionLocation;

- (CGPoint) selectionScreenPoint;

- (UIColor*) color;

- (Boolean) shouldCreateView;

@end

NS_ASSUME_NONNULL_END
