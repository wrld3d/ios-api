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
#import "WRLDSearchWidgetStyle.h"
#import "WRLDSearchMenuModel.h"
#import "WRLDSearchMenuViewController.h"

@interface WRLDSearchWidgetViewController()
@property (unsafe_unretained, nonatomic) IBOutlet WRLDSearchBar *searchBar;

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
    WRLDSearchMenuViewController* m_searchMenuViewController;
    NSString * m_suggestionsTableViewCellStyleIdentifier;
    NSString * m_searchResultsTableViewDefaultCellStyleIdentifier;
    
    WRLDSearchQuery * m_mostRecentQuery;
    
    NSInteger maxVisibleCollapsedResults;
    NSInteger maxVisibleExpandedResults;
    
    NSInteger maxVisibleSuggestions;
    
    UIColor * m_primaryBackgroundColor;
    UIColor * m_primaryForegroundColor;
    UIColor * m_focusBackgroundColor;
    UIColor * m_focusForegroundColor;
    UIColor * m_disabledBackgroundColor;
    UIColor * m_disabledForegroundColor;
    
    id<WRLDViewVisibilityController> m_activeResultsView;
    
    BOOL m_hasFocus;
}

- (WRLDSearchResultSelectedObserver *)searchSelectionObserver
{
    return m_searchResultsViewController.selectionObserver;
}

- (WRLDSearchResultSelectedObserver *)suggestionSelectionObserver
{
    return m_suggestionsViewController.selectionObserver;
}

- (WRLDMenuObserver *)menuObserver
{
    return m_searchMenuViewController.observer;
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
        
        m_hasFocus = NO;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    m_searchResultsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.resultsTableView
                                                                                    visibilityView: self.resultsTableContainerView
                                                                                             style: self.style
                                                                                  heightConstraint:self.resultsTableHeightConstraint
                                                                             defaultCellIdentifier:m_searchResultsTableViewDefaultCellStyleIdentifier];
    
    m_suggestionsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.suggestionsTableView
                                                                                  visibilityView: self.suggestionsTableContainerView
                                                                                           style: self.style
                                                                                heightConstraint:self.suggestionsTableHeightConstraint
                                                                           defaultCellIdentifier:m_suggestionsTableViewCellStyleIdentifier];

    m_searchMenuViewController = [[WRLDSearchMenuViewController alloc] initWithMenuModel:m_menuModel
                                                                          visibilityView:self.menuContainerView
                                                                              titleLabel:self.menuTitleLabel
                                                                           separatorView:self.menuSeparator
                                                                               tableView:self.menuTableView
                                                                        tableFadeTopView:self.menuTableFadeTop
                                                                     tableFadeBottomView:self.menuTableFadeBottom
                                                                        heightConstraint:self.menuContainerViewHeightConstraint
                                                                                   style:self.style];
    
    [self setupStyle];
    [self observeModel];
}
    
- (void) observeModel
{
    [m_suggestionsViewController.selectionObserver addResultSelectedEvent:^(id<WRLDSearchResultModel> selectedResultModel) {
        self.searchBar.text = selectedResultModel.title;
        [self triggerSearch : selectedResultModel.title];
    }];
    
    [m_searchModel.searchObserver addQueryStartingEvent: ^(WRLDSearchQuery * query)
     {
         [m_searchResultsViewController showQuery: query];
         m_activeResultsView = m_searchResultsViewController;
         if(m_hasFocus)
         {
             [m_suggestionsViewController hide];
             [m_searchResultsViewController show];
         }
     }];
    
    [m_searchModel.searchObserver addQueryCompletedEvent: ^(WRLDSearchQuery * query)
     {
         [m_searchResultsViewController showQuery: query];
         if(m_searchResultsViewController.visibleResults == 0)
         {
             m_activeResultsView = self.noResultsVisibilityController;
             if(m_hasFocus)
             {
                 [m_searchResultsViewController hide];
                 [self.noResultsVisibilityController show];
             }
         }
         else
         {
             m_activeResultsView = m_searchResultsViewController;
         }
     }];
    
    [m_searchModel.suggestionObserver addQueryCompletedEvent: ^(WRLDSearchQuery * query)
     {
         [m_suggestionsViewController showQuery: query];
         [m_searchResultsViewController hide];
         if(m_hasFocus)
         {
             [m_suggestionsViewController show];
         }
         m_activeResultsView = m_suggestionsViewController;
     }];
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

- (void) searchBarTextDidBeginEditing:(WRLDSearchBar *)searchBar
{
    [searchBar setActive: true];
    if(m_activeResultsView != nil)
    {
        [m_activeResultsView show];
    }
    m_hasFocus = YES;
}

- (void) searchBarTextDidEndEditing:(WRLDSearchBar *)searchBar
{
    [searchBar setActive: false];
}

- (void) resignFocus
{
    if(self.searchBar.isFirstResponder)
    {
        [self.searchBar resignFirstResponder];
    }
    
    if(m_activeResultsView != nil)
    {
        [m_activeResultsView hide];
    }
    m_hasFocus = NO;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *trimmedSearchText = [searchText stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];

    if(m_mostRecentQuery && [trimmedSearchText isEqualToString: m_mostRecentQuery.queryString])
    {
        return;
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
    [m_searchResultsViewController displayResultsFrom: searchProvider
                               maxToShowWhenCollapsed: maxVisibleCollapsedResults
                                maxToShowWhenExpanded: maxVisibleExpandedResults];
}

- (void) stopDisplayingSearchProvider :(WRLDSearchProviderHandle *) searchProvider
{
    [m_searchResultsViewController stopDisplayingResultsFrom: searchProvider];
}

- (void) displaySuggestionProvider :(WRLDSuggestionProviderHandle *) suggestionProvider
{
    [m_suggestionsViewController displayResultsFrom: suggestionProvider
                             maxToShowWhenCollapsed: maxVisibleSuggestions
                              maxToShowWhenExpanded: maxVisibleSuggestions];
}

- (void) stopDisplayingSuggestionProvider :(WRLDSuggestionProviderHandle *) suggestionProvider
{
    [m_suggestionsViewController stopDisplayingResultsFrom: suggestionProvider];
}

-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
{
    [self.resultsTableView registerNib:nib forCellReuseIdentifier: cellIdentifier];
}

- (void)openMenu
{
    [self resignFocus];
    [m_searchMenuViewController show];
}

- (void)closeMenu
{
    [m_searchMenuViewController hide];
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
    // TODO: allow developers to hook onto button touch so they can optionally expand the or collapse menu options
    [self resignFocus];
    [m_searchMenuViewController onMenuButtonClicked];
}

- (IBAction)menuBackButtonClicked:(id)backButton
{
    [m_searchMenuViewController onMenuBackButtonClicked];
}

@end

