//
//  IndoorControl.m
//  ios-sdk
//
//  Created by Paul Harris on 02/05/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#import "IndoorControl.h"

@implementation IndoorControl

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"IndoorControl"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        xibView.frame = self.bounds;
//        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: xibView];
    }
    return self;
}

- (IBAction)exitIndoorMap:(id)sender {
}
@end
