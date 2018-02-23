#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchModel;
@class WRLDSearchProviderHandle;
@class WRLDSuggestionProviderHandle;
@class WRLDSearchResultSelectedObserver;

@interface WRLDSearchWidgetViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, readonly) WRLDSearchResultSelectedObserver * searchSelectionObserver;
@property (nonatomic, readonly) WRLDSearchResultSelectedObserver * suggestionSelectionObserver;

-(instancetype) initWithSearchModel: (WRLDSearchModel *) model;
-(void) displaySearchProvider :(WRLDSearchProviderHandle*) searchProvider;
-(void) displaySuggestionProvider :(WRLDSuggestionProviderHandle*) suggestionProvider;
-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib;

- (void) resignFocus;

@end
