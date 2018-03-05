#import "WRLDHighlightableButton.h"
#import "WRLDSearchWidgetStyle.h"


@implementation WRLDHighlightableButton
{
    UIColor * m_highlightBackgroundColor;
    UIColor * m_normalBackgroundColor;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    m_normalBackgroundColor = self.backgroundColor;
    m_highlightBackgroundColor = self.backgroundColor;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    m_normalBackgroundColor = self.backgroundColor;
    return self;
}

- (void)applyStyle:(WRLDSearchWidgetStyle *)style
{
    m_normalBackgroundColor = [style colorForStyle:WRLDSearchWidgetStylePrimaryColor];
    m_highlightBackgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuIconColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? m_highlightBackgroundColor : m_normalBackgroundColor;
}

@end
