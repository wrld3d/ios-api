#import "AppMapViewDelegate.h"

@import Wrld;

@interface LabelWithMargin : UILabel

- (instancetype)initWithMessage:(NSString *) message;

@end

@implementation LabelWithMargin

- (instancetype)initWithMessage:(NSString *) message
{
    self = [super init];
    
    self.text = message;
    self.textColor = UIColor.lightTextColor;
    self.backgroundColor = [UIColor.darkGrayColor colorWithAlphaComponent:0.8];
    self.numberOfLines = 0;
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 8, 0, 8))];
}


- (void)layoutSubviews
{
    CGRect parentFrame = self.superview.frame;
    
    const CGFloat height = 64.0;
    const CGFloat border = 16.0;
    
    self.frame = CGRectMake(0.0, parentFrame.size.height - height - border, parentFrame.size.width - border*2, height);
    self.center = CGPointMake(self.superview.center.x, self.center.y);
    
    [super layoutSubviews];
}


@end

@interface SamplesMessage : NSObject

+ (void)showWithMessage:(NSString *)message;

+ (void)showWithMessage:(NSString *)message
            andDuration:(NSNumber*)duration;

@end

@implementation SamplesMessage

+(void)showWithMessage:(NSString *)message
{
    [self showWithMessage:message andDuration:nil];
}


+(void)showWithMessage:(NSString *)message andDuration:(NSNumber*)duration
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

        LabelWithMargin* label = [[LabelWithMargin alloc] initWithMessage:message];
        [mainWindow addSubview:label];
        
        [UIView animateWithDuration: 1.0
                              delay: duration ? duration.doubleValue : 5.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^ {
                             label.alpha = 0.0;
                         }
                         completion: ^(BOOL finished) {
                             [label removeFromSuperview];
                         }
         ];
    }];
}

@end


@implementation AppMapViewDelegate


-(void)initialMapSceneLoaded:(WRLDMapView *)mapView
{
    [SamplesMessage showWithMessage:@"Streaming of initial map scene completed."];
}

@end


