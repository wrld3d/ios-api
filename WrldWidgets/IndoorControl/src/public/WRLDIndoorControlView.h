#import <UIKit/UIKit.h>
@import Wrld;

@interface WRLDIndoorControlView : UIView <WRLDIndoorMapDelegate>

- (void) didEnterIndoorMap;
- (void) didExitIndoorMap;

@end
