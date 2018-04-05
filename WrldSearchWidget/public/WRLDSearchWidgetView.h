#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchModel;
@class WRLDSearchMenuModel;
@class WRLDSearchProviderHandle;
@class WRLDSuggestionProviderHandle;
@class WRLDSearchResultSelectedObserver;
@class WRLDMenuObserver;
@class WRLDSearchWidgetObserver;
@class WRLDSearchWidgetStyle;
@class WRLDSpeechHandler;

@interface WRLDSearchWidgetView : UIView <UISearchBarDelegate>

@property (nonatomic, readonly) WRLDSearchResultSelectedObserver * searchSelectionObserver;
@property (nonatomic, readonly) WRLDSearchResultSelectedObserver * suggestionSelectionObserver;
@property (nonatomic, readonly) WRLDMenuObserver * menuObserver;
@property (nonatomic, readonly) WRLDSearchWidgetObserver * observer;
@property (nonatomic, readonly) WRLDSearchWidgetStyle * style;
@property (nonatomic, readonly) BOOL searchBarIsFirstResponder;
@property (nonatomic, readonly) BOOL isMenuOpen;
@property (nonatomic, readonly) BOOL isResultsViewVisible;
@property (nonatomic, readonly) BOOL searchbarHasFocus;
@property (nonatomic, readonly) BOOL hasSearchResults;
@property (nonatomic, readonly) BOOL hasFocus;

- (void) useSearchModel: (WRLDSearchModel *) searchModel;
- (void) useMenuModel: (WRLDSearchMenuModel *) menuModel;

- (void) deregisterFromSearchModel;
- (void) deregisterFromMenuModel;

- (void) displaySearchProvider: (WRLDSearchProviderHandle*) searchProvider;
- (void) stopDisplayingSearchProvider: (WRLDSearchProviderHandle*) searchProvider;

- (void) displaySuggestionProvider: (WRLDSuggestionProviderHandle*) suggestionProvider;
- (void) stopDisplayingSuggestionProvider: (WRLDSuggestionProviderHandle*) suggestionProvider;

- (void) registerNib: (UINib *) nib forUseWithResultsTableCellIdentifier: (NSString *) cellIdentifier;

- (void) clearSearch;
- (void) showResultsView;
- (void) hideResultsView;

- (void) resignFocus;

- (void) openMenu;
- (void) closeMenu;
- (void) collapseMenu;
- (void) expandMenuOptionAt: (NSUInteger)index;

- (void) enableVoiceSearch: (WRLDSpeechHandler*)speechHandler;
- (void) disableVoiceSearch;

- (void) setSearchBarPlaceholder: (NSString*)placeholder;

@end