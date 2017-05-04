//
//  DebugIndoorControl.m
//  ios-sdk
//
//  Created by Paul Harris on 02/05/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#import "DebugIndoorControl.h"

@implementation DebugIndoorControl

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"DebugIndoorControl"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        xibView.frame = self.bounds;
        [self addSubview: xibView];
    }
    return self;
}

- (IBAction)exitIndoorMap:(id)sender {
}
@end
