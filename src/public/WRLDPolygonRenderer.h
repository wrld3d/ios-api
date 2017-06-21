#pragma once

#import <WRLD/WRLDPolygon.h>

@class WRLDOverlay;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDOverlayRenderer : NSObject

- (instancetype)initWithOverlay:(id <WRLDOverlay>)overlay ;

@property (nonatomic, readonly) id <WRLDOverlay> overlay;

@end

///---------

@interface WRLDPolygonRenderer : WRLDOverlayRenderer

- (instancetype)initWithPolygon:(WRLDPolygon *)polygon;
@property (nonatomic, readonly) WRLDPolygon *polygon;

@property (strong, nullable) UIColor *fillColor;

@end

NS_ASSUME_NONNULL_END
