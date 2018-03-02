#import "WRLDMenuOptionTableViewCell.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDMenuOptionTableViewCell
{
    UIImage* m_expanderIcon;
    UIImage* m_highlightedIcon;
    WRLDSearchWidgetStyle* m_style;
    bool m_needsBottomSeparator;
}

- (void)populateWith:(WRLDMenuTableSectionViewModel *)viewModel
        expanderIcon:(UIImage *)expanderIcon
     highlightedIcon:(UIImage *)highlightedIcon
               style:(WRLDSearchWidgetStyle *)style
{
    m_expanderIcon = expanderIcon;
    m_highlightedIcon = highlightedIcon;
    m_style = style;
    
    self.label.text = [viewModel getText];
    
    bool needsExpander = [viewModel isExpandable];
    [self.expander setHidden:!needsExpander];
    
    bool needsGroupSeparator = [viewModel isFirstOptionInGroup];
    [self.groupSeparator setHidden:!needsGroupSeparator];
    self.groupSeparator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleDividerMajorColor];
    
    bool isExpanded = viewModel.expandedState == Expanded;
    m_needsBottomSeparator = ![viewModel isLastOptionInGroup] && !isExpanded;
    [self.separator setHidden:!m_needsBottomSeparator];
    self.separator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleDividerMinorColor];
    
    [UIView animateWithDuration: 0.2f animations:^{
        CGFloat degrees = isExpanded ? 270.0f : 0.0f;
        CGFloat radians = degrees * M_PI/180;
        self.expander.transform = CGAffineTransformMakeRotation(radians);
    }];
    
    if (isExpanded)
    {
        self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupExpandedColor];
        self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextExpandedColor];
        [self.expander setImage:m_highlightedIcon];
    }
    else
    {
        self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupCollapsedColor];
        self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextCollapsedColor];
        [self.expander setImage:m_expanderIcon];
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
        self.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuGroupExpandedColor];
        self.label.textColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextExpandedColor];
        [self.separator setHidden:YES];
        [self.expander setImage:m_highlightedIcon];
    }
    else
    {
        self.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuGroupCollapsedColor];
        self.label.textColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextCollapsedColor];
        [self.separator setHidden:!m_needsBottomSeparator];
        [self.expander setImage:m_expanderIcon];
    }
}

@end
