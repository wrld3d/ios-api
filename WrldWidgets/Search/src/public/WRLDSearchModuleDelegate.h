#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchResult.h"

/*!
 This delegate is used to interface the search module with views.
 */
@protocol WRLDSearchModuleDelegate

/*!
 This will be called when the contents of the model changes.
 */
- (void) dataDidChange;

/*!
 Called when a search result is selected in the table.
 @param searchResult - The selected result.
 */
- (void) didSelectResult: (WRLDSearchResult*) searchResult;

/*!
 Called to get a table cell. This will be called when the search table view requires a cell view for
 a search result.

 @param tableView The table that this cell is for.
 @param indexPath The index of the cell in the table.
 @param searchResult The search result that should be used to populate the view.
 @returns The cell view.
 */
- (UITableViewCell*) createTableViewCellForSearch: (UITableView*)tableView
                                    cellIndexPath: (NSIndexPath*)indexPath
                                     searchResult: (WRLDSearchResult*)searchResult;

@end
