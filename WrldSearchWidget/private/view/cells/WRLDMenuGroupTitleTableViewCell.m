#import "WRLDMenuGroupTitleTableViewCell.h"
#import "WRLDMenuTableSectionViewModel.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDMenuGroupTitleTableViewCell

- (void)populateWith:(WRLDMenuTableSectionViewModel *)viewModel
 isFirstTableSection:(bool)isFirstTableSection
               style:(WRLDSearchWidgetStyle *)style
{
    self.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMenuOptionCollapsedColor];
    
    self.label.text = [viewModel getText];
    self.label.textColor = [style colorForStyle:WRLDSearchWidgetStyleMenuOptionTextCollapsedColor];
    
    bool needsGroupSeparator = !isFirstTableSection;
    [self.groupSeparator setHidden:!needsGroupSeparator];
    self.groupSeparator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMajorDividerColor];
    
    bool needsBottomSeparator = ![viewModel isLastOptionInGroup];
    [self.separator setHidden:!needsBottomSeparator];
    self.separator.backgroundColor = [style colorForStyle:WRLDSearchWidgetStyleMinorDividerColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
