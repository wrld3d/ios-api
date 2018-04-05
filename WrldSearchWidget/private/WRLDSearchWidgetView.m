#import "WRLDSearchWidgetView.h"
#import "WRLDSearchBar.h"
#import "WRLDSearchProviderHandle.h"
#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSearchWidgetTableViewController.h"
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchResultModel.h"
#import "WRLDSearchModel.h"
#import "WRLDSearchQueryObserver.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchResultSelectedObserver.h"
#import "WRLDSearchResultSelectedObserver+Private.h"
#import "WRLDMenuObserver.h"
#import "WRLDSearchWidgetObserver.h"
#import "WRLDSearchWidgetObserver+Private.h"
#import "WRLDSearchWidgetStyle.h"
#import "WRLDSearchMenuModel.h"
#import "WRLDSearchMenuViewController.h"
#import "WRLDSearchWidgetResultsTableDataSource.h"
#import "WRLDSpeechHandler+Private.h"

@interface WRLDSearchWidgetView()

@property (weak, nonatomic) IBOutlet UIView *view;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *searchBarSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *voiceOptionSubView;

@property (unsafe_unretained, nonatomic) IBOutlet WRLDSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceButtonWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingInProgressActivityIndicator;

@property (weak, nonatomic) IBOutlet UIView *resultsTableContainerView;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultsTableHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *suggestionsTableContainerView;
@property (weak, nonatomic) IBOutlet UITableView *suggestionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionsTableHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView* noResultsView;
@property (weak, nonatomic) IBOutlet UILabel* noResultsLabel;
@property (weak, nonatomic) IBOutlet id<WRLDViewVisibilityController> noResultsVisibilityController;

@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuSeparator;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *menuTableFadeTop;
@property (weak, nonatomic) IBOutlet UIView *menuTableFadeBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuContainerViewHeightConstraint;

@end

@implementation WRLDSearchWidgetView
{
    WRLDSearchModel* m_searchModel;
    WRLDSearchMenuModel* m_menuModel;
    WRLDSearchWidgetTableViewController* m_searchResultsViewController;
    WRLDSearchWidgetTableViewController* m_suggestionsViewController;
    WRLDSearchWidgetResultsTableDataSource* m_searchResultsDataSource;
    WRLDSearchWidgetResultsTableDataSource* m_suggestionsDataSource;
    WRLDSearchMenuViewController* m_searchMenuViewController;
    NSString * m_suggestionsTableViewCellStyleIdentifier;
    NSString * m_searchResultsTableViewDefaultCellStyleIdentifier;
    
    WRLDSpeechHandler* m_speechHandler;
    
    NSInteger maxVisibleCollapsedResults;
    NSInteger maxVisibleExpandedResults;
    
    NSInteger maxVisibleSuggestions;
    
    id<WRLDViewVisibilityController> m_activeResultsViewVisibilityController;

    BOOL m_searchHasFocus;
    BOOL m_willShowResultsViews;
    BOOL m_isSearchResultsViewVisible;
    
    __weak QueryEvent m_searchQueryStartedEvent;
    __weak QueryEvent m_searchQueryCompletedEvent;
    __weak QueryEvent m_suggestionQueryCompletedEvent;
    
    __weak VoiceAuthorizedEvent m_speechHandlerAuthChangedEvent;
    __weak VoiceEvent m_speechHandlerCancelledEvent;
    __weak VoiceRecordedEvent m_speechHandlerCompletedEvent;
    
    __weak OpenedEvent m_menuOpenedEvent;
    __weak ClosedEvent m_menuClosedEvent;
}

#pragma mark - UIView Extended

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initMembers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initMembers];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if([self subviewContainsEvent: self.menuContainerView point: point event: event])
    {
        return YES;
    }
    if([self subviewContainsEvent: self.searchBarSubView point: point event: event])
    {
        return YES;
    }
    if([self subviewContainsEvent: self.voiceOptionSubView point: point event: event])
    {
        return YES;
    }
    if([self subviewContainsEvent: self.resultsTableContainerView point: point event: event])
    {
        return YES;
    }
    if([self subviewContainsEvent: self.suggestionsTableContainerView point: point event: event])
    {
        return YES;
    }
    
    [self resignFocus];
    
    return NO;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.frame;
    rect.origin = self.view.frame.origin;
    self.view.frame = rect;
}

-(void) willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview: newSuperview];
    
    if(@available(iOS 10.0, *))
    {
        [m_speechHandler authorize];
    }
}

#pragma mark - API

- (WRLDSearchResultSelectedObserver *)searchSelectionObserver
{
    return m_searchResultsDataSource.selectionObserver;
}

- (WRLDSearchResultSelectedObserver *)suggestionSelectionObserver
{
    return m_suggestionsDataSource.selectionObserver;
}

- (WRLDMenuObserver *)menuObserver
{
    return m_searchMenuViewController.observer;
}

- (BOOL) searchBarIsFirstResponder
{
    return self.searchBar.isFirstResponder;
}

- (BOOL)isMenuOpen
{
    return [m_searchMenuViewController isMenuOpen];
}

- (BOOL) isResultsViewVisible
{
    return m_willShowResultsViews;
}

- (BOOL)hasSearchResults
{
    return m_searchResultsDataSource.visibleResults > 0;
}

- (BOOL) hasFocus
{
    return m_searchHasFocus || self.isMenuOpen;
}

- (void) useSearchModel: (WRLDSearchModel *) searchModel
{
    if(m_searchModel)
    {
        [self deregisterFromSearchModel];
    }
    
    m_searchModel = searchModel;
    
    QueryEvent searchQueryStartedEvent = ^(WRLDSearchQuery * query)
    {
        [self.searchBar setText:query.queryString];
        
        [m_searchResultsDataSource updateResultsFrom: query];
        [m_searchResultsViewController refreshTable];
        [self determineVoiceButtonVisibility];
        [self showSearchResultsView];
        BOOL showNumResults = NO;
        
        [self refreshSearchBarTextForCurrentQuery: showNumResults];
        [self startSearchInProgressAnimation];
    };
    
    QueryEvent searchQueryCompletedEvent = ^(WRLDSearchQuery * query)
    {
        [m_searchResultsDataSource updateResultsFrom: query];
        [m_searchResultsViewController refreshTable];
        
        if(m_searchResultsDataSource.visibleResults == 0)
        {
            [self showNoResultsView];
        }
        else
        {
            [self.observer receiveSearchResults];
            [self showSearchResultsView];
        }
        
        BOOL showNumResults = !m_willShowResultsViews;
        [self refreshSearchBarTextForCurrentQuery: showNumResults];
        [self stopSearchInProgressAnimation];
    };
    
    QueryEvent suggestionQueryCompletedEvent = ^(WRLDSearchQuery * query)
    {
        [m_suggestionsDataSource updateResultsFrom: query];
        [m_suggestionsViewController refreshTable];
        [self showSuggestionsView];
    };
    
    // observers will hold strong references to block events to increase reference counter
    [m_searchModel.searchObserver addQueryStartingEvent: searchQueryStartedEvent];
    [m_searchModel.searchObserver addQueryCompletedEvent: searchQueryCompletedEvent];
    [m_searchModel.suggestionObserver addQueryCompletedEvent: suggestionQueryCompletedEvent];
    
    // self will weakly hold on to block event to remove from observer later and prevent circular references
    m_searchQueryStartedEvent = searchQueryStartedEvent;
    m_searchQueryCompletedEvent = searchQueryCompletedEvent;
    m_suggestionQueryCompletedEvent = suggestionQueryCompletedEvent;
}

- (void) useMenuModel: (WRLDSearchMenuModel *) menuModel
{
    if(m_menuModel)
    {
        [self deregisterFromMenuModel];
    }
    
    m_menuModel = menuModel;
    
    OpenedEvent menuOpenedEvent = ^(BOOL fromInteraction)
    {
        if(!m_searchHasFocus && fromInteraction)
        {
            [self.observer searchWidgetGainFocus];
        }
    };
    
    ClosedEvent menuClosedEvent = ^(BOOL fromInteraction)
    {
        if(fromInteraction)
        {
            [self.observer searchWidgetResignFocus];
        }
    };
    
    // observer will hold strong references to block events to increase reference counter
    [self.menuObserver addOpenedEvent: menuOpenedEvent];
    [self.menuObserver addClosedEvent: menuClosedEvent];
    
    // self will weakly hold on to block event to remove from observer later and prevent circular references
    m_menuOpenedEvent = menuOpenedEvent;
    m_menuClosedEvent = menuClosedEvent;
    
    [m_searchMenuViewController setModel:m_menuModel];
    
    [self.menuButton setHidden:NO];
    [self.searchbarLeadingConstraint setConstant: 0];
}

- (void) deregisterFromSearchModel
{
    if(!m_searchModel)
    {
        return;
    }
    
    if(m_searchQueryStartedEvent)
    {
        [m_searchModel.searchObserver removeQueryStartingEvent: m_searchQueryStartedEvent];
    }
    
    if(m_searchQueryCompletedEvent)
    {
        [m_searchModel.searchObserver removeQueryCompletedEvent: m_searchQueryCompletedEvent];
    }
    
    if(m_suggestionQueryCompletedEvent)
    {
        [m_searchModel.suggestionObserver removeQueryCompletedEvent: m_suggestionQueryCompletedEvent];
    }
    
    m_searchModel = nil;
}

- (void) deregisterFromMenuModel
{
    if(m_menuModel == nil)
    {
        return;
    }
    
    if(self.menuObserver)
    {
        [self.menuObserver removeOpenedEvent: m_menuOpenedEvent];
    }
    
    if(m_menuClosedEvent)
    {
        [self.menuObserver removeClosedEvent: m_menuClosedEvent];
    }
    
    [self.menuButton setHidden:NO];
    [self.searchbarLeadingConstraint setConstant:-self.menuButtonWidthConstraint.constant];
    
    [m_searchMenuViewController removeModel];
    m_menuModel = nil;
}

- (void) displaySearchProvider :(WRLDSearchProviderHandle *) searchProvider
{
    [m_searchResultsDataSource displayResultsFrom: searchProvider
                           maxToShowWhenCollapsed: maxVisibleCollapsedResults
                            maxToShowWhenExpanded: maxVisibleExpandedResults];
}

- (void) stopDisplayingSearchProvider :(WRLDSearchProviderHandle *) searchProvider
{
    [m_searchResultsDataSource stopDisplayingResultsFrom: searchProvider];
}

- (void) displaySuggestionProvider :(WRLDSuggestionProviderHandle *) suggestionProvider
{
    [m_suggestionsDataSource displayResultsFrom: suggestionProvider
                         maxToShowWhenCollapsed: maxVisibleCollapsedResults
                          maxToShowWhenExpanded: maxVisibleSuggestions];
}

- (void) stopDisplayingSuggestionProvider :(WRLDSuggestionProviderHandle *) suggestionProvider
{
    [m_suggestionsDataSource stopDisplayingResultsFrom: suggestionProvider];
}

-(void) registerNib:(UINib *)nib forUseWithResultsTableCellIdentifier:(NSString *)cellIdentifier
{
    [self.resultsTableView registerNib:nib forCellReuseIdentifier: cellIdentifier];
}

- (void) clearSearch
{
    [self.searchBar setText:@""];
}

- (void) showResultsView
{
    BOOL hadFocus = self.hasFocus;
    if(m_activeResultsViewVisibilityController != nil)
    {
        BOOL animateIn = YES;
        [m_activeResultsViewVisibilityController show: animateIn];
        m_willShowResultsViews = YES;
        BOOL showNumResults = NO;
        [self refreshSearchBarTextForCurrentQuery: showNumResults];
        
        if (m_activeResultsViewVisibilityController == m_searchResultsViewController)
        {
            [self searchResultsViewBecameVisibleDispatch];
        }
    }
    
    if(!hadFocus)
    {
        m_searchHasFocus = true;
        [_observer searchWidgetGainFocus];
    }
}

- (void) hideResultsView
{
    BOOL hadFocus = self.hasFocus;
    
    [self searchbarResignFocus];
    [self minimiseSearchView];
    
    if(hadFocus)
    {
        m_searchHasFocus = false;
        [_observer searchWidgetResignFocus];
    }
}

- (void) resignFocus
{
    BOOL hadFocus = self.hasFocus;
    if(m_searchHasFocus)
    {
        [self minimiseSearchView];
        m_searchHasFocus = NO;
    }
    if(self.isMenuOpen)
    {
        [m_searchMenuViewController close];
    }
    
    if(hadFocus)
    {
        [_observer searchWidgetResignFocus];
    }
}

- (void)openMenu
{
    bool hadFocus = self.hasFocus;
    [self minimiseSearchView];
    [m_searchMenuViewController open];
    if(!hadFocus)
    {
        [_observer searchWidgetGainFocus];
    }
}

- (void)closeMenu
{
    bool hadFocus = self.hasFocus;
    [m_searchMenuViewController close];
    if(hadFocus){
        [_observer searchWidgetResignFocus];
    }
}

- (void)collapseMenu
{
    [m_searchMenuViewController collapse];
}

- (void)expandMenuOptionAt:(NSUInteger)index
{
    [m_searchMenuViewController expandAt:index];
}

- (void)enableVoiceSearch:(WRLDSpeechHandler*)speechHandler
{
    if(@available(iOS 10.0, *))
    {
        if(m_speechHandler != nil) {
            [self disableVoiceSearch];
        }
        
        m_speechHandler = speechHandler;
        
        [self observeSpeechHandler: speechHandler];
        [self determineVoiceButtonVisibility];
    }
    else
    {
        NSLog(@"Cannot enable voice search on iOS Versions less than 10.0");
    }
}

- (void)disableVoiceSearch
{
    if(m_speechHandler != nil && m_speechHandler.isRecording) {
        [m_speechHandler endRecording];
    }
    
    [self stopObservingSpeechHandler: m_speechHandler];
    
    m_speechHandler = nil;
    [self determineVoiceButtonVisibility];
}

- (void) setSearchBarPlaceholder:(NSString*)placeholder
{
    [self.searchBar setPlaceholder:placeholder];
}

#pragma mark - UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(WRLDSearchBar *)searchBar
{
    [searchBar setActive: true];
    [self showResultsView];
    m_searchHasFocus = YES;
    
    BOOL showNumResults = NO;
    [self refreshSearchBarTextForCurrentQuery: showNumResults];
    
    if (!_searchbarHasFocus)
    {
        _searchbarHasFocus = YES;
        [self.observer searchbarGainFocus];
    }
}

- (void) searchBarTextDidEndEditing:(WRLDSearchBar *)searchBar
{
    [searchBar setActive:false];
    [self searchbarResignFocus];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // TODO: we don't trim text in Android. Should porbably make one consistent with the other
    NSString *trimmedSearchText = [searchText stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
    
    bool hasSearchQueryAndNewTextDiffers = [m_searchModel isCurrentQueryForSearch] && ![trimmedSearchText isEqualToString: [m_searchModel getCurrentQuery].queryString];
    
    if (hasSearchQueryAndNewTextDiffers)
    {
        [m_searchModel cancelCurrentQuery];
        [self clearSearchResults];
    }
    
    if([trimmedSearchText length] > 0)
    {
        [m_searchModel getSuggestionsForString: trimmedSearchText];
    }
    else
    {
        // TODO: should probably split search model into a suggestions model or at least separate the queries
        [m_searchModel cancelCurrentQuery];
        
        // TODO: should probably be done as a side effect of clearing the suggestions, like in Android.
        BOOL animateOut = YES;
        [m_suggestionsViewController hide: animateOut];
        m_activeResultsViewVisibilityController = nil;
    }
    
    [self determineVoiceButtonVisibility];
    [self stopSearchInProgressAnimation];
}

#pragma mark - Implementation - UIView Extend

- (void) initMembers
{
    m_suggestionsTableViewCellStyleIdentifier = @"WRLDSuggestionTableViewCell";
    m_searchResultsTableViewDefaultCellStyleIdentifier = @"WRLDSearchResultTableViewCell";
    
    maxVisibleCollapsedResults = 3;
    maxVisibleExpandedResults = 100;
    
    maxVisibleSuggestions = 3;
    
    _style = [[WRLDSearchWidgetStyle alloc] init];
    _observer = [[WRLDSearchWidgetObserver alloc] init];
    
    m_searchHasFocus = NO;
    m_willShowResultsViews = NO;
    m_isSearchResultsViewVisible = NO;
    _searchbarHasFocus = NO;
    
    m_searchResultsDataSource = [[WRLDSearchWidgetResultsTableDataSource alloc]
                                 initWithDefaultCellIdentifier: m_searchResultsTableViewDefaultCellStyleIdentifier];
    
    m_suggestionsDataSource = [[WRLDSearchWidgetResultsTableDataSource alloc]
                               initWithDefaultCellIdentifier: m_suggestionsTableViewCellStyleIdentifier];
    
    m_speechHandler = nil;
    
    [self setupView];
    [self setupStyle];
}

-(BOOL) subviewContainsEvent: (UIView*) view
                       point: (CGPoint)point
                       event: (UIEvent*) event
{
    if (view.userInteractionEnabled && ![view isHidden] && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
        return YES;
    }
    return NO;
}

-(void) setupView
{
    NSBundle *bundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    [bundle loadNibNamed:@"WRLDSearchWidget" owner:self options:nil];
    [self addSubview: self.view];
    
    m_searchResultsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.resultsTableView
                                                                                        dataSource: m_searchResultsDataSource
                                                                                    visibilityView: self.resultsTableContainerView
                                                                                  heightConstraint:self.resultsTableHeightConstraint
                                                                                             style:self.style];
    
    m_suggestionsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.suggestionsTableView
                                                                                      dataSource: m_suggestionsDataSource
                                                                                  visibilityView: self.suggestionsTableContainerView
                                                                                heightConstraint:self.suggestionsTableHeightConstraint
                                                                                           style:self.style];
    
    m_searchMenuViewController = [[WRLDSearchMenuViewController alloc] initWithVisibilityView:self.menuContainerView
                                                                                   titleLabel:self.menuTitleLabel
                                                                                separatorView:self.menuSeparator
                                                                                    tableView:self.menuTableView
                                                                             tableFadeTopView:self.menuTableFadeTop
                                                                          tableFadeBottomView:self.menuTableFadeBottom
                                                                             heightConstraint:self.menuContainerViewHeightConstraint
                                                                                        style:self.style];
    
    [m_suggestionsDataSource.selectionObserver addResultSelectedEvent:^(id<WRLDSearchResultModel> selectedResultModel) {
        self.searchBar.text = selectedResultModel.title;
        [self triggerSearch : selectedResultModel.title];
    }];
    
    SearchResultsSourceEvent resultsSectionExpandedStateChangedEvent = ^() {
        [self searchbarResignFocus];
    };
    
    [self.menuButton setHidden:YES];
    [self.searchbarLeadingConstraint setConstant:-self.menuButtonWidthConstraint.constant];
    
    [m_searchResultsDataSource addResultsSectionExpandedEvent:resultsSectionExpandedStateChangedEvent];
    
    [self.voiceButtonWidthConstraint setConstant:0];
    [self determineVoiceButtonVisibility];
}

- (void) setupStyle
{
    [self.style call:^(UIColor *color) {
        self.resultsTableContainerView.backgroundColor = color;
    } toApply:WRLDSearchWidgetStylePrimaryColor];
    
    [self.style call:^(UIColor *color) {
        self.suggestionsTableContainerView.backgroundColor = color;
        self.noResultsView.backgroundColor = color;
    } toApply:WRLDSearchWidgetStyleSecondaryColor];
    
    [self.searchBar applyStyle: self.style];
    
    [self.style call:^(UIColor *color) {
        self.noResultsLabel.textColor = color;
    } toApply:WRLDSearchWidgetStyleWarningColor];
}

#pragma mark - Implementation - API

-(void)startSearchInProgressAnimation{
    [self.loadingInProgressActivityIndicator startAnimating];
}

-(void)stopSearchInProgressAnimation{
    [self.loadingInProgressActivityIndicator stopAnimating];
}

- (void) showNoResultsView
{
    if(m_willShowResultsViews)
    {
        BOOL animateOut = NO;
        [m_suggestionsViewController hide: animateOut];
        [m_searchResultsViewController hide: animateOut];
        
        if (m_activeResultsViewVisibilityController == m_searchResultsViewController)
        {
            [self searchResultsViewBecameHiddenDispatch];
        }
        
        BOOL animateIn = YES;
        [self.noResultsVisibilityController show: animateIn];
    }
    m_activeResultsViewVisibilityController = self.noResultsVisibilityController;
}

- (void) showSearchResultsView
{
    if(m_willShowResultsViews)
    {
        BOOL animateOut = NO;
        [m_suggestionsViewController hide: animateOut];
        [self.noResultsVisibilityController hide: animateOut];
        
        BOOL animateIn = YES;
        [m_searchResultsViewController show: animateIn];
        [self searchResultsViewBecameVisibleDispatch];
    }
    m_activeResultsViewVisibilityController = m_searchResultsViewController;
}

- (void) showSuggestionsView
{
    m_willShowResultsViews = YES;
    BOOL animateOut = NO;
    [m_searchResultsViewController hide: animateOut];
    [self.noResultsVisibilityController hide: animateOut];
        
    if (m_activeResultsViewVisibilityController == m_searchResultsViewController)
    {
        [self searchResultsViewBecameHiddenDispatch];
    }
        
    BOOL animateIn = YES;
    [m_suggestionsViewController show: animateIn];
    m_activeResultsViewVisibilityController = m_suggestionsViewController;
}

- (void) minimiseSearchView
{
    [self searchbarResignFocus];
    [self animateOutActiveView];
    BOOL showNumResults = YES;
    [self refreshSearchBarTextForCurrentQuery: showNumResults];
}

- (void) animateOutActiveView
{
    if(m_activeResultsViewVisibilityController != nil)
    {
        BOOL animateOut = YES;
        [m_activeResultsViewVisibilityController hide: animateOut];
        
        if (m_activeResultsViewVisibilityController == m_searchResultsViewController)
        {
            [self searchResultsViewBecameHiddenDispatch];
        }
        m_willShowResultsViews = NO;
    }
}

- (void)searchbarResignFocus
{
    if (self.searchBar.isFirstResponder)
    {
        [self.searchBar resignFirstResponder];
    }
    
    if (_searchbarHasFocus)
    {
        _searchbarHasFocus = NO;
        [self.observer searchbarResignFocus];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self triggerSearch: searchBar.text];
}

- (void) triggerSearch : (NSString *) queryString
{
    BOOL animateOut = YES;
    [m_suggestionsViewController hide: animateOut];
    [m_searchModel getSearchResultsForString: queryString];
    [self.searchBar resignFirstResponder];
}

- (void)clearSearchResults
{
    [self animateOutActiveView];
    
    BOOL showNumResults = NO;
    [self refreshSearchBarTextForCurrentQuery: showNumResults];
    
    [m_searchResultsDataSource clearResults];
    [self.observer clearSearchResults];
}

- (void)searchResultsViewBecameVisibleDispatch
{
    if (!m_isSearchResultsViewVisible)
    {
        m_isSearchResultsViewVisible = YES;
        [self.observer showSearchResults];
    }
}

- (void)searchResultsViewBecameHiddenDispatch
{
    if (m_isSearchResultsViewVisible)
    {
        m_isSearchResultsViewVisible = NO;
        [self.observer hideSearchResults];
    }
}

-(void) refreshSearchBarTextForCurrentQuery: (BOOL) showNumResults
{
    if(showNumResults)
    {
        if([m_searchResultsDataSource getDisplayedQueryText] != nil &&
           !m_searchModel.isSearchQueryInFlight) {
            [self.searchBar setText:[NSString stringWithFormat: @"%@ (%ld)",
                                     [m_searchResultsDataSource getDisplayedQueryText],
                                     (long)[m_searchResultsDataSource getTotalResultCount]]];
        }
    }
    else
    {
        if([m_searchResultsDataSource getDisplayedQueryText] != nil) {
            [self.searchBar setText:[NSString stringWithFormat: @"%@", [m_searchResultsDataSource getDisplayedQueryText]]];
        }
    }
}

- (IBAction)menuButtonClicked:(id)menuButton
{
    [self minimiseSearchView];
    [m_searchMenuViewController onMenuButtonClicked];
}

- (IBAction)menuBackButtonClicked:(id)backButton
{
    [m_searchMenuViewController onMenuBackButtonClicked];
}

#pragma mark - Implementation - Speech

- (BOOL)showVoiceButton
{
    if(@available(iOS 10.0, *))
    {
        return m_speechHandler != nil && [m_speechHandler isAuthorized];
    }
    else return NO;
}

- (void) determineVoiceButtonVisibility {
    if( [[self.searchBar text] length] > 0)
    {
        if(![self.voiceButton isHidden]) {
            [UIView animateWithDuration:0.25 animations:^{
                [self.voiceButtonWidthConstraint setConstant:0];
            } completion:^(BOOL finished) {
                if(finished) {
                    self.voiceButton.hidden = YES;
                }
            }];
        }
    }
    else {
        if([self showVoiceButton] && self.voiceButtonWidthConstraint.constant < 32)
        {
            self.voiceButton.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                [self.voiceButtonWidthConstraint setConstant:32];
            }];
        }
    }
}

-(void) observeSpeechHandler: (WRLDSpeechHandler*)speechHandler
{
    VoiceAuthorizedEvent voiceAuthorizedChangedEvent = ^(BOOL authorized)
    {
        [self determineVoiceButtonVisibility];
    };
    
    VoiceEvent voiceRecordCancelEvent = ^()
    {
        [self cancelVoiceSearch];
    };
    
    VoiceRecordedEvent voiceRecordCompleteEvent = ^(NSString* transcript)
    {
        [self.searchBar setUserInteractionEnabled:YES];
        [m_searchModel getSearchResultsForString:transcript];
        [self showResultsView];
    };
    
    [speechHandler.observer addAuthorizationChangedEvent:voiceAuthorizedChangedEvent];
    [speechHandler.observer addVoiceRecordCancelledEvent:voiceRecordCancelEvent];
    [speechHandler.observer addVoiceRecordCompleteEvent:voiceRecordCompleteEvent];
    
    m_speechHandlerAuthChangedEvent = voiceAuthorizedChangedEvent;
    m_speechHandlerCancelledEvent = voiceRecordCancelEvent;
    m_speechHandlerCompletedEvent = voiceRecordCompleteEvent;
}

-(void) stopObservingSpeechHandler: (WRLDSpeechHandler*)speechHandler
{
    [speechHandler.observer removeAuthorizationChangedEvent:m_speechHandlerAuthChangedEvent];
    [speechHandler.observer removeVoiceRecordCancelledEvent:m_speechHandlerCancelledEvent];
    [speechHandler.observer removeVoiceRecordCompleteEvent:m_speechHandlerCompletedEvent];

    m_speechHandlerAuthChangedEvent = nil;
    m_speechHandlerCancelledEvent = nil;
    m_speechHandlerCompletedEvent = nil;
}

- (IBAction) voiceButtonClicked:(id)sender
{
    if(!m_speechHandler.isRecording)
    {
        [m_speechHandler startRecording];
        [self.searchBar setUserInteractionEnabled:NO];
    }
    else
    {
        [m_speechHandler endRecording];
    }
}

-(void)cancelVoiceSearch
{
    [self.searchBar setUserInteractionEnabled:YES];
}

@end
