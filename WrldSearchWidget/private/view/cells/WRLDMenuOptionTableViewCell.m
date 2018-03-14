#import "WRLDMenuOptionTableViewCell.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDMenuOptionTableViewCell
{
    WRLDSearchWidgetStyle* m_style;
    bool m_isExpanded;
}

- (void)populateWith:(WRLDMenuTableSectionViewModel *)viewModel
 isFirstTableSection:(bool)isFirstTableSection
        expanderIcon:(UIImage *)expanderIcon
     highlightedIcon:(UIImage *)highlightedIcon
               style:(WRLDSearchWidgetStyle *)style
{
    m_style = style;
    
    self.label.text = [viewModel getText];
    
    bool needsExpander = [viewModel isExpandable];
    [self.expander setHidden:!needsExpander];
    
    bool needsGroupSeparator = [viewModel isFirstOptionInGroup] && !isFirstTableSection;
    [self.groupSeparator setHidden:!needsGroupSeparator];
    self.groupSeparator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleDividerColor];
    
    m_isExpanded = viewModel.expandedState == Expanded;
    bool needsBottomSeparator = ![viewModel isLastOptionInGroup] && !m_isExpanded;
    [self.separator setHidden:!needsBottomSeparator];
    self.separator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleDividerColor];
    
    [UIView animateWithDuration: 0.2f animations:^{
        CGFloat degrees = m_isExpanded ? 270.0f : 0.0f;
        CGFloat radians = degrees * M_PI/180;
        self.expander.transform = CGAffineTransformMakeRotation(radians);
    }];
    
    if (m_isExpanded)
    {
        self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupExpandedColor];
        self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextExpandedColor];
        [self.expander setImage:highlightedIcon];
    }
    else
    {
        self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupCollapsedColor];
        self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextCollapsedColor];
        [self.expander setImage:expanderIcon];
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
        self.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuHoverColor];
        self.label.textColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextHoverColor];
    }
    else
    {
        self.backgroundColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuGroupCollapsedColor];
        self.label.textColor = [m_style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextCollapsedColor];
    }
}

@end
