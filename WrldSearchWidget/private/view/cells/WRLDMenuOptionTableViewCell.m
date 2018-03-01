#import "WRLDMenuOptionTableViewCell.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDMenuOptionTableViewCell

- (void)populateWith:(WRLDMenuTableSectionViewModel *)viewModel
       collapsedIcon:(UIImage *)collapsedIcon
        expandedIcon:(UIImage *)expandedIcon
               style:(WRLDSearchWidgetStyle *)style
{
    self.label.text = [viewModel getText];
    
    bool needsExpander = [viewModel isExpandable];
    [self.expander setHidden:!needsExpander];
    
    bool needsGroupSeparator = [viewModel isFirstOptionInGroup];
    [self.groupSeparator setHidden:!needsGroupSeparator];
    self.groupSeparator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleDividerMajorColor];
    
    bool isExpanded = viewModel.expandedState == Expanded;
    bool needsBottomSeparator = ![viewModel isLastOptionInGroup] && !isExpanded;
    [self.separator setHidden:!needsBottomSeparator];
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
        [self.expander setImage:expandedIcon];
    }
    else
    {
        self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupCollapsedColor];
        self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextCollapsedColor];
        [self.expander setImage:collapsedIcon];
    }
}

@end
