#import "WRLDSearchWidgetViewController.h"
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
#import "WRLDSpeechHandler.h"
#import "WRLDSearchWidgetView.h"

@interface WRLDSearchWidgetViewController()
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

@implementation WRLDSearchWidgetViewController
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
    
    WRLDSearchQuery * m_mostRecentQuery;
    
    NSInteger maxVisibleCollapsedResults;
    NSInteger maxVisibleExpandedResults;
    
    NSInteger maxVisibleSuggestions;
    
    id<WRLDViewVisibilityController> m_activeResultsView;

    BOOL m_hasFocus;
    
    __weak QueryEvent m_searchQueryStartedEvent;
    __weak QueryEvent m_searchQueryCompletedEvent;
    __weak QueryEvent m_suggestionQueryCompletedEvent;
}

- (BOOL) searchBarIsFirstResponder
{
    return self.searchBar.isFirstResponder;
}

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

- (BOOL)isMenuOpen
{
    return [m_searchMenuViewController isMenuOpen];
}

- (BOOL)hasSearchResults
{
    return m_activeResultsView == m_searchResultsViewController && m_searchResultsDataSource.visibleResults > 0;
}

- (instancetype)initWithSearchModel:(WRLDSearchModel *)searchModel
{
    return [self initWithSearchModel:searchModel
                           menuModel:nil];
}

- (instancetype)initWithSearchModel:(WRLDSearchModel *)searchModel
                          menuModel:(WRLDSearchMenuModel *)menuModel
{
    NSBundle* bundle = [NSBundle bundleForClass:[WRLDSearchWidgetViewController class]];
    self = [super initWithNibName: @"WRLDSearchWidget" bundle:bundle];
    if(self)
    {
        m_searchModel = searchModel;
        m_menuModel = menuModel;
        m_suggestionsTableViewCellStyleIdentifier = @"WRLDSuggestionTableViewCell";
        m_searchResultsTableViewDefaultCellStyleIdentifier = @"WRLDSearchResultTableViewCell";
        
        maxVisibleCollapsedResults = 3;
        maxVisibleExpandedResults = 100;
        
        maxVisibleSuggestions = 3;
        
        _style = [[WRLDSearchWidgetStyle alloc] init];
        _observer = [[WRLDSearchWidgetObserver alloc] init];
        
        m_hasFocus = NO;
        _searchbarHasFocus = NO;
        
        m_searchResultsDataSource = [[WRLDSearchWidgetResultsTableDataSource alloc]
                                     initWithDefaultCellIdentifier: m_searchResultsTableViewDefaultCellStyleIdentifier];
        
        m_suggestionsDataSource = [[WRLDSearchWidgetResultsTableDataSource alloc]
                                   initWithDefaultCellIdentifier: m_suggestionsTableViewCellStyleIdentifier];
        
        CGRect fullScreen = [[UIScreen mainScreen] bounds];
        m_speechHandler = [[WRLDSpeechHandler alloc] initWithFrame:fullScreen];
        [self.view addSubview:m_speechHandler];
        
        // TODO: Discuss better way to handling this so SpeechHandler can handle widget input.
        [(WRLDSearchWidgetView*)(self.view) setSpeechHandler: m_speechHandler];
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
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

    m_searchMenuViewController = [[WRLDSearchMenuViewController alloc] initWithMenuModel:m_menuModel
                                                                          visibilityView:self.menuContainerView
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
    
    if (m_menuModel == nil)
    {
        [self.menuButton setHidden:YES];
        [self.searchbarLeadingConstraint setConstant:-self.menuButtonWidthConstraint.constant];
    }
    
    [self.voiceButtonWidthConstraint setConstant:0];
    [self determineVoiceButtonVisibility];
    [self setupVoiceControl];
    
    [self setupStyle];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self observeModel: m_searchModel];
    
    if(@available(iOS 10.0, *))
    {
        [m_speechHandler authorize];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopObservingModel: m_searchModel];
}
    
- (void) observeModel: (WRLDSearchModel *) model
{
    if(m_searchModel)
    {
        [self stopObservingModel: m_searchModel];
    }
    
    m_searchModel = model;
    
    QueryEvent searchQueryStartedEvent = ^(WRLDSearchQuery * query)
    {
        [self.searchBar setText:query.queryString];
        
        [m_searchResultsDataSource updateResultsFrom: query];
        [m_searchResultsViewController refreshTable];
        [self determineVoiceButtonVisibility];
        m_activeResultsView = m_searchResultsViewController;
        if(m_hasFocus)
        {
            [m_suggestionsViewController hide];
            [self.noResultsVisibilityController hide];
            [m_searchResultsViewController show];
        }
        
        [self refreshSearchBarTextForCurrentQuery];
        [self startSearchInProgressAnimation];
    };
    
    QueryEvent searchQueryCompletedEvent = ^(WRLDSearchQuery * query)
    {
        [m_searchResultsDataSource updateResultsFrom: query];
        [m_searchResultsViewController refreshTable];
     
        if(m_searchResultsDataSource.visibleResults == 0)
        {
            m_activeResultsView = self.noResultsVisibilityController;
            if(_isResultsViewVisible)
            {
                [m_searchResultsViewController hide];
                [self.noResultsVisibilityController show];
            }
        }
        else
        {
            m_activeResultsView = m_searchResultsViewController;
            [self.observer receiveSearchResults];
            if(_isResultsViewVisible)
            {
                [m_searchResultsViewController show];
                [self.noResultsVisibilityController hide];
            }
            [self.observer showSearchResults];
        }
        
        [self refreshSearchBarTextForCurrentQuery];
        [self stopSearchInProgressAnimation];
    };
    
    QueryEvent suggestionQueryCompletedEvent = ^(WRLDSearchQuery * query)
    {
        [m_suggestionsDataSource updateResultsFrom: query];
        [m_suggestionsViewController refreshTable];
        [m_searchResultsViewController hide];
        if(m_hasFocus)
        {
            [m_suggestionsViewController show];
        }
        m_activeResultsView = m_suggestionsViewController;
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

-(void)startSearchInProgressAnimation{
    [self.loadingInProgressActivityIndicator startAnimating];
}

-(void)stopSearchInProgressAnimation{
    [self.loadingInProgressActivityIndicator stopAnimating];
}

- (void) stopObservingModel: (WRLDSearchModel *) model
{
    if(!model)
    {
        return;
    }
    
    if(m_searchQueryStartedEvent)
    {
        [model.searchObserver removeQueryStartingEvent: m_searchQueryStartedEvent];
    }
    
    if(m_searchQueryCompletedEvent)
    {
        [model.searchObserver removeQueryCompletedEvent: m_searchQueryCompletedEvent];
    }
    
    if(m_suggestionQueryCompletedEvent)
    {
        [model.suggestionObserver removeQueryCompletedEvent: m_suggestionQueryCompletedEvent];
    }
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

- (void) setSearchBarPlaceholder:(NSString*)placeholder
{
    [self.searchBar setPlaceholder:placeholder];
}

- (void) searchBarTextDidBeginEditing:(WRLDSearchBar *)searchBar
{
    [searchBar setActive: true];
    [self showResultsView];
    m_hasFocus = YES;
    
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

- (void) resignFocus
{
    [self searchbarResignFocus];
    [self hideResultsView];
    m_hasFocus = NO;
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

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *trimmedSearchText = [searchText stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];

    if(m_mostRecentQuery && [trimmedSearchText isEqualToString: m_mostRecentQuery.queryString])
    {
        return;
    }
    
    if ([searchText length] == 0)
    {
        if (m_activeResultsView == m_searchResultsViewController)
        {
            [self.observer clearSearchResults];
        }
    }
    
    [m_searchResultsViewController hide];
    [self.noResultsVisibilityController hide];
    
    [self cancelMostRecentQueryIfNotComplete];
    
    if([trimmedSearchText length] > 0)
    {
        m_mostRecentQuery = [m_searchModel getSuggestionsForString: trimmedSearchText];
    }
    else
    {
        [m_suggestionsViewController hide];
        m_activeResultsView = nil;
    }
    
    [self determineVoiceButtonVisibility];
    [self stopSearchInProgressAnimation];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self triggerSearch: searchBar.text];
}

- (void) triggerSearch : (NSString *) queryString
{
    [self cancelMostRecentQueryIfNotComplete];
    [m_suggestionsViewController hide];
    m_mostRecentQuery = [m_searchModel getSearchResultsForString: queryString];
    [self.searchBar resignFirstResponder];
}

- (void) cancelMostRecentQueryIfNotComplete
{
    if(!m_mostRecentQuery.hasCompleted)
    {
        [m_mostRecentQuery cancel];
        m_mostRecentQuery = nil;
    }
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
    if(m_activeResultsView != nil)
    {
        [m_activeResultsView show];
        if (!_isResultsViewVisible)
        {
            _isResultsViewVisible = YES;
            if (m_activeResultsView == m_searchResultsViewController)
            {
                [self.observer showSearchResults];
            }
        }
        
        [self refreshSearchBarTextForCurrentQuery];
    }
}

- (void) hideResultsView
{
    if(m_activeResultsView != nil)
    {
        [m_activeResultsView hide];
        
        if (_isResultsViewVisible)
        {
            _isResultsViewVisible = NO;
            if (m_activeResultsView == m_searchResultsViewController)
            {
                [self.observer hideSearchResults];
            }
        }
        
        [self refreshSearchBarTextForCurrentQuery];
    }
}

-(void) refreshSearchBarTextForCurrentQuery
{
    if(_isResultsViewVisible)
    {
        if([m_searchResultsDataSource getDisplayedQueryText] != nil) {
            [self.searchBar setText:[NSString stringWithFormat: @"%@", [m_searchResultsDataSource getDisplayedQueryText]]];
        }
    }
    else
    {
        if([m_searchResultsDataSource getDisplayedQueryText] != nil &&
           !m_searchModel.isSearchQueryInFlight) {
            [self.searchBar setText:[NSString stringWithFormat: @"%@ (%ld)",
                                     [m_searchResultsDataSource getDisplayedQueryText],
                                     (long)[m_searchResultsDataSource getTotalResultCount]]];
        }
    }
        
}

- (void)openMenu
{
    [self resignFocus];
    [m_searchMenuViewController open];
}

- (void)closeMenu
{
    [m_searchMenuViewController close];
}

- (void)collapseMenu
{
    [m_searchMenuViewController collapse];
}

- (void)expandMenuOptionAt:(NSUInteger)index
{
    [m_searchMenuViewController expandAt:index];
}

- (IBAction)menuButtonClicked:(id)menuButton
{
    [self resignFocus];
    [m_searchMenuViewController onMenuButtonClicked];
}

- (IBAction)menuBackButtonClicked:(id)backButton
{
    [m_searchMenuViewController onMenuBackButtonClicked];
}

- (BOOL)showVoiceButton
{
    if(@available(iOS 10.0, *))
    {
        return [m_speechHandler isEnabled] && [m_speechHandler isAuthorized];
    }
    else return NO;
}

- (void)enableVoiceSearch:(NSString*)promptText
{
    if(@available(iOS 10.0, *))
    {
        [m_speechHandler enableWithPrompt:promptText];
        [self determineVoiceButtonVisibility];
    }
    else
    {
        NSLog(@"Cannot enable voice search on iOS Versions less than 10.0");
    }
}

- (void)disableVoiceSearch
{
    [m_speechHandler disable];
    [self determineVoiceButtonVisibility];
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

-(void) setupVoiceControl
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
    
    // TODO: Remove these where?
    [m_speechHandler.observer addAuthorizationChangedEvent:voiceAuthorizedChangedEvent];
    [m_speechHandler.observer addVoiceRecordCancelledEvent:voiceRecordCancelEvent];
    [m_speechHandler.observer addVoiceRecordCompleteEvent:voiceRecordCompleteEvent];
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

