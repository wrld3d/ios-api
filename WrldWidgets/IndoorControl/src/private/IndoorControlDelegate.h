@protocol IndoorControlDelegate <NSObject>

@optional

- (void) onCancelButtonPressed;

- (void) onFloorSliderPressed;
- (void) onFloorSliderDragged:(float)floorInterpolation;
- (void) onFloorSliderReleased:(int)floorIndex;

@end
