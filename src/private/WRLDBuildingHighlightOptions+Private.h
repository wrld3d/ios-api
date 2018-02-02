#pragma once

#import "WRLDBuildingHighlightOptions.h"
#import "WRLDBuildingHighlightSelectionMode.h"
#import "WRLDScreenProperties.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDBuildingHighlightOptions;

@interface WRLDBuildingHighlightOptions (Private)

- (instancetype) initWithLocation:(CLLocationCoordinate2D)location;

- (instancetype) initWithScreenPoint:(CGPoint)screenPoint
                    screenProperties:(WRLDScreenProperties)screenProperties;

- (WRLDBuildingHighlightSelectionMode) selectionMode;

- (CLLocationCoordinate2D) selectionLocation;

- (CGPoint) selectionScreenPoint;

- (UIColor*) color;

- (Boolean) shouldCreateView;

- (WRLDScreenProperties) screenProperties;

@end

NS_ASSUME_NONNULL_END
