#import "WRLDRouteViewOptions.h"
#import "WRLDRouteViewOptions+Private.h"

@interface WRLDRouteViewOptions ()

@end

@implementation WRLDRouteViewOptions
{
    CGFloat m_width;
    UIColor* m_color;
    UIColor* m_forwardPathColor;
    CGFloat m_miterLimit;
}

- (instancetype)init
{
    if (self = [super init])
    {
        m_width = 10.f;
        m_color = [UIColor colorWithRed:0 green:(150.f/255.f) blue:1.f alpha:1.f];
        m_forwardPathColor = [UIColor colorWithRed:0 green:1.f blue:(150.f/255.f) alpha:1.f];
        m_miterLimit = 10.0f;
    }
    
    return self;
}

- (WRLDRouteViewOptions*) width:(CGFloat)width
{
    m_width = width;
    return self;
}

- (WRLDRouteViewOptions*) color:(UIColor*)color
{
    m_color = color;
    return self;
}

- (WRLDRouteViewOptions*) forwardPathColor:(UIColor*)color
{
    m_forwardPathColor = color;
    return self;
}

- (WRLDRouteViewOptions*) miterLimit:(CGFloat)miterLimit
{
    m_miterLimit = miterLimit;
    return self;
}

- (CGFloat) getWidth
{
    return m_width;
}

- (UIColor*) getColor
{
    return m_color;
}

-(UIColor*) getForwardPathColor
{
    return m_forwardPathColor;
}

- (CGFloat) getMiterLimit
{
    return m_miterLimit;
}

@end
