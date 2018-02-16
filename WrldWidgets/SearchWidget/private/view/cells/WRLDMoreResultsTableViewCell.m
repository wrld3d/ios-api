#import <Foundation/Foundation.h>
#import "WRLDMoreResultsTableViewCell.h"
#import "WRLDSearchWidgetResultSetViewModel.h"

@implementation WRLDMoreResultsTableViewCell

- (void) populateWith: (WRLDSearchWidgetResultSetViewModel*) resultsViewModel
{
    self.moreResultsLabel.text = [NSString stringWithFormat:@"Show More (%d) %@ results", ([resultsViewModel getResultCount] - [resultsViewModel getVisibleResultCount]), resultsViewModel.moreResultsName];
}

@end
