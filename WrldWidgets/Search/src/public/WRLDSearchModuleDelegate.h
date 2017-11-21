#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchResult.h"

@protocol WRLDSearchModuleDelegate

- (void) dataDidChange;

- (void) didSelectResult: (WRLDSearchResult*) searchResult;

- (UITableViewCell*) createTableViewCellForSearch: (UITableView*)tableView cellIndexPath: (NSIndexPath*)indexPath searchResult: (WRLDSearchResult*)searchResult;

@end
