#import "WRLDViewAnchor.h"

@implementation WRLDViewAnchor

+ (void)positionView:(UIView *)view
         screenPoint:(CGPoint *)screenPoint
            anchorUV:(CGPoint *)anchorUV
{
    CGRect frame = view.frame;
    frame.origin.x = (screenPoint->x/[UIScreen mainScreen].scale) - (frame.size.width*anchorUV->x);
    frame.origin.y = (screenPoint->y/[UIScreen mainScreen].scale) - (frame.size.height*anchorUV->y);
    view.frame = frame;
}

@end
