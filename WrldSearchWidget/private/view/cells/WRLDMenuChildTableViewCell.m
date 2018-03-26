#import "WRLDMenuChildTableViewCell.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDSearchWidgetStyle.h"
#import "WRLDMenuChild.h"

@implementation WRLDMenuChildTableViewCell
{
    WRLDSearchWidgetStyle* m_style;
}

- (void)populateWith:(WRLDMenuTableSectionViewModel *)viewModel
          childIndex:(NSUInteger)childIndex
               style:(WRLDSearchWidgetStyle *)style
{
    m_style = style;
    
    WRLDMenuChild* menuChild = [viewModel getChildAtIndex:childIndex];
    
    self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleSecondaryColor];
    self.backgroundPanel.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStylePrimaryColor];
    
    self.label.text = menuChild != nil ? menuChild.text : @"";
    self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuOptionTextCollapsedColor];
    
    // TODO: set icon
    //[self.icon setImage:icon];
    
    bool isFirstChild = childIndex == 0;
    bool isLastChild = childIndex == [viewModel getChildCount] - 1;
    
    [self.separator setHidden:isLastChild];
    self.separator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMinorDividerColor];
    
    CAGradientLayer* gradient = [[CAGradientLayer alloc] init];
    gradient.frame = self.shadowGradient.bounds;
    
    [self.shadowGradient setHidden:NO];
    self.shadowGradient.layer.mask = gradient;
    
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    if (isFirstChild && isLastChild)
    {
        gradient.colors = @[(__bridge id)outerColor, (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor];
        gradient.locations = @[@0.0, @0.2, @0.8, @1.0];
    }
    else if (isFirstChild)
    {
        gradient.colors = @[(__bridge id)outerColor, (__bridge id)innerColor];
        gradient.locations = @[@0.0, @0.2];
    }
    else if (isLastChild)
    {
        gradient.colors = @[(__bridge id)innerColor, (__bridge id)outerColor];
        gradient.locations = @[@0.8, @1.0];
    }
    else
    {
        [self.shadowGradient setHidden:YES];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted
              animated:(BOOL)animated
{
    if (m_style == nil)
    {
        return;
    }
    
    if (highlighted)
    {
        self.backgroundPanel.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuChildOptionHoverColor];
    }
    else
    {
        self.backgroundPanel.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStylePrimaryColor];
    }
}

@end
