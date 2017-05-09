//
//  IndoorControlViewController.h
//  ios-sdk
//
//  Created by Paul Harris on 04/05/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Wrld;

@interface IndoorControlViewController : UIView <WRLDIndoorMapDelegate>

- (void) didEnterIndoorMap;
- (void) didExitIndoorMap;

@end
