#import "WRLDMenuOptionTableViewCell.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDMenuOptionTableViewCell
{
    WRLDSearchWidgetStyle* m_style;
    UIImage* m_expanderIcon;
    UIImage* m_highlightedExpanderIcon;
    bool m_needsExpander;
    bool m_isExpanded;
}

- (void)populateWith:(WRLDMenuTableSectionViewModel *)viewModel
 isFirstTableSection:(bool)isFirstTableSection
        expanderIcon:(UIImage *)expanderIcon
     highlightedIcon:(UIImage *)highlightedIcon
               style:(WRLDSearchWidgetStyle *)style
{
    m_style = style;
    m_expanderIcon = expanderIcon;
    m_highlightedExpanderIcon = highlightedIcon;
    
    self.label.text = [viewModel getText];
    
    m_needsExpander = [viewModel isExpandable];
    [self.expander setHidden:!m_needsExpander];
    
    bool needsGroupSeparator = [viewModel isFirstOptionInGroup] && !isFirstTableSection;
    [self.groupSeparator setHidden:!needsGroupSeparator];
    self.groupSeparator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMajorDividerColor];
    
    m_isExpanded = viewModel.expandedState == Expanded;
    bool needsBottomSeparator = ![viewModel isLastOptionInGroup] && !m_isExpanded;
    [self.separator setHidden:!needsBottomSeparator];
    self.separator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMinorDividerColor];
    
    [UIView animateWithDuration: 0.2f animations:^{
        CGFloat degrees = m_isExpanded ? 270.0f : 0.0f;
        CGFloat radians = degrees * M_PI/180;
        self.expander.transform = CGAffineTransformMakeRotation(radians);
    }];
    
    if (m_isExpanded)
    {
        self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuOptionExpandedColor];
        self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuOptionTextExpandedColor];
        [self.expander setImage:m_highlightedExpanderIcon];
    }
    else
    {
        self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuOptionCollapsedColor];
        self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuOptionTextCollapsedColor];
        [self.expander setImage:m_expanderIcon];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted
              animated:(BOOL)animated
{
    if (m_style == nil || m_isExpanded)
    {
        return;
    }
    
    if (highlighted)
    {
        self.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuOptionHoverColor];
        self.label.textColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuOptionTextHoverColor];
    }
    else
    {
        self.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuOptionCollapsedColor];
        self.label.textColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuOptionTextCollapsedColor];
    }
    
    [self.expander setImage:(highlighted ? m_highlightedExpanderIcon : m_expanderIcon)];
}

@end
