#import <Foundation/Foundation.h>

@class WRLDMapView;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (IBAdditions)

@property (nonatomic) IBInspectable double latitude;
@property (nonatomic) IBInspectable double longitude;
@property (nonatomic) IBInspectable double zoomLevel;
@property (nonatomic) IBInspectable double direction;

@end

NS_ASSUME_NONNULL_END
