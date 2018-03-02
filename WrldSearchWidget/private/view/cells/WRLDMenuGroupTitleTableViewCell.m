#import "WRLDMenuGroupTitleTableViewCell.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDMenuGroupTitleTableViewCell

- (void)populateWith:(WRLDMenuTableSectionViewModel *)viewModel
 isFirstTableSection:(bool)isFirstTableSection
               style:(WRLDSearchWidgetStyle *)style
{
    self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupCollapsedColor];
    
    self.label.text = [viewModel getText];
    self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuGroupTextCollapsedColor];
    
    bool needsGroupSeparator = !isFirstTableSection;
    [self.groupSeparator setHidden:!needsGroupSeparator];
    self.groupSeparator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleDividerMajorColor];
    
    bool needsBottomSeparator = ![viewModel isLastOptionInGroup];
    [self.separator setHidden:!needsBottomSeparator];
    self.separator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleDividerMinorColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
