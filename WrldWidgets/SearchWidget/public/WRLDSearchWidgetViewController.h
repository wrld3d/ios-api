#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchModel;
@class WRLDSearchProviderHandle;
@class WRLDSuggestionProviderHandle;

@interface WRLDSearchWidgetViewController : UIViewController <UISearchBarDelegate>
-(instancetype) initWithSearchModel: (WRLDSearchModel *) model;
-(void) displaySearchProvider :(WRLDSearchProviderHandle*) searchProvider;
-(void) displaySuggestionProvider :(WRLDSuggestionProviderHandle*) suggestionProvider;
-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib;
@end
