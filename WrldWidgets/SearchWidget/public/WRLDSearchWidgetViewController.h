#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchProvider;
@protocol WRLDSuggestionProvider;
@class WRLDSearchModel;
@class WRLDSearchProviderReference;
@class WRLDSuggestionProviderReference;

@interface WRLDSearchWidgetViewController : UIViewController <UISearchBarDelegate>
-(instancetype) initWithSearchModel: (WRLDSearchModel *) model;
-(void) displaySearchProvider :(WRLDSearchProviderReference*) searchProvider;
-(void) displaySuggestionProvider :(WRLDSuggestionProviderReference*) suggestionProvider;
-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib;
@end
