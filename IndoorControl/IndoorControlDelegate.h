@protocol IndoorControlDelegate <NSObject>

@optional

- (void) onCancelButtonPressed;
- (void) onFloorSliderReleased:(int)floorIndex;

@end
