#import "WRLDHighlightableButton.h"


@implementation WRLDHighlightableButton
{
    NSMutableDictionary<NSNumber *, UIColor *>* m_controlStateColors;
    UIColor * m_highlightBackgroundColor;
    UIColor * m_normalBackgroundColor;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    m_normalBackgroundColor = self.backgroundColor;
    m_highlightBackgroundColor = self.backgroundColor;
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    m_normalBackgroundColor = self.backgroundColor;
    return self;
}

- (void) setBackgroundColor:(UIColor *)color forState:(UIControlState) controlState
{
    if(color == nil)
    {
        return;
    }
    
    if(controlState == UIControlStateNormal)
    {
        m_normalBackgroundColor = color;
    }
    else if(controlState == UIControlStateHighlighted)
    {
        m_highlightBackgroundColor = color;
    }
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
        
    if(highlighted)
    {
        self.backgroundColor = m_highlightBackgroundColor;
    }
    else
    {
        self.backgroundColor = m_normalBackgroundColor;
    }
}

@end
