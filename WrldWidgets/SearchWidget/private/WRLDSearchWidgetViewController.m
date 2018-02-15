#import "WRLDSearchWidgetViewController.h"
#import "WRLDSearchBar.h"
#import "WRLDSearchProviderHandle.h"
#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSearchWidgetTableViewController.h"
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchModel.h"
#import "WRLDSearchQueryObserver.h"
#import "WRLDSearchQuery.h"

@interface WRLDSearchWidgetViewController()
@property (unsafe_unretained, nonatomic) IBOutlet WRLDSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet UIView *resultsTableContainerView;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultsHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *suggestionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionsHeightConstraint;

@end

@implementation WRLDSearchWidgetViewController
{
    WRLDSearchModel* m_searchModel;
    WRLDSearchWidgetTableViewController* m_searchResultsViewController;
    WRLDSearchWidgetTableViewController* m_suggestionsViewController;
    NSString * m_suggestionsTableViewCellStyleIdentifier;
    NSString * m_searchResultsTableViewDefaultCellStyleIdentifier;
    NSString * m_moreResultsCellStyleIdentifier;
    NSString * m_searchInProgressCellStyleIdentifier;
    
    WRLDSearchQuery * m_mostRecentQuery;
}

- (instancetype) initWithSearchModel : (WRLDSearchModel *) searchModel
{
    NSBundle* bundle = [NSBundle bundleForClass:[WRLDSearchWidgetViewController class]];
    self = [super initWithNibName: @"WRLDSearchWidget" bundle:bundle];
    if(self)
    {
        m_searchModel = searchModel;
        m_suggestionsTableViewCellStyleIdentifier = @"WRLDSuggestionTableViewCell";
        m_searchResultsTableViewDefaultCellStyleIdentifier = @"WRLDSearchResultTableViewCell";
        m_moreResultsCellStyleIdentifier = @"WRLDMoreResultsTableViewCell";
        m_searchInProgressCellStyleIdentifier = @"WRLDSearchInProgressTableViewCell";
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchResultTableViewCell class]];
    [self initialiseSearchResultsTableViewWithResourcesFrom: widgetsBundle];
    [self initialiseSuggestionTableViewWithResourcesFrom: widgetsBundle];
    
    [m_searchModel.searchObserver addQueryStartingEvent: ^(WRLDSearchQuery * query)
     {
         [m_searchResultsViewController showQuery: query];
         [m_searchResultsViewController show];
         [m_suggestionsViewController hide];
     }];
    
    [m_searchModel.searchObserver addQueryCompletedEvent: ^(WRLDSearchQuery * query)
     {
         [m_searchResultsViewController showQuery: query];
     }];
    
    [m_searchModel.suggestionObserver addQueryCompletedEvent: ^(WRLDSearchQuery * query)
     {
         [m_suggestionsViewController showQuery: query];
         [m_searchResultsViewController hide];
         [m_suggestionsViewController show];
     }];
}

- (void) searchBarTextDidBeginEditing:(WRLDSearchBar *)searchBar
{
    [searchBar setActive: true];
}

- (void) searchBarTextDidEndEditing:(WRLDSearchBar *)searchBar
{
    [searchBar setActive: false];
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
    
    [self cancelMostRecentQueryIfNotComplete];
    
    if([trimmedSearchText length] > 0)
    {
        m_mostRecentQuery = [m_searchModel getSuggestionsForString: trimmedSearchText];
    }
    else
    {
        [m_suggestionsViewController hide];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self cancelMostRecentQueryIfNotComplete];
    [m_suggestionsViewController hide];
    m_mostRecentQuery = [m_searchModel getSearchResultsForString: searchBar.text];
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

- (void) initialiseSearchResultsTableViewWithResourcesFrom :(NSBundle*) resourceBundle
{
    m_searchResultsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.resultsTableView
                                                                                    visibilityView: self.resultsTableContainerView
                                                                                  heightConstraint:self.resultsHeightConstraint
                                                                             defaultCellIdentifier:m_searchResultsTableViewDefaultCellStyleIdentifier];

    [self.resultsTableView registerNib:[UINib nibWithNibName: m_searchResultsTableViewDefaultCellStyleIdentifier bundle:resourceBundle]
                forCellReuseIdentifier: m_searchResultsTableViewDefaultCellStyleIdentifier];
    [self.resultsTableView registerNib:[UINib nibWithNibName:m_moreResultsCellStyleIdentifier bundle: resourceBundle]
                forCellReuseIdentifier: m_moreResultsCellStyleIdentifier];
    [self.resultsTableView registerNib:[UINib nibWithNibName:m_searchInProgressCellStyleIdentifier bundle: resourceBundle]
                forCellReuseIdentifier: m_searchInProgressCellStyleIdentifier];
}

- (void) initialiseSuggestionTableViewWithResourcesFrom :(NSBundle*) resourceBundle
{
    m_suggestionsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.suggestionsTableView
                                                                                  visibilityView: self.suggestionsTableView
                                                                                heightConstraint:self.suggestionsHeightConstraint
                                                                           defaultCellIdentifier:m_suggestionsTableViewCellStyleIdentifier];
    
    self.suggestionsTableView.sectionHeaderHeight = 0;
    self.suggestionsTableView.sectionFooterHeight = 0;
    
    UINib * nib = [UINib nibWithNibName: m_suggestionsTableViewCellStyleIdentifier bundle: resourceBundle];
    [self.suggestionsTableView registerNib:nib forCellReuseIdentifier: m_suggestionsTableViewCellStyleIdentifier];
}

- (void) displaySearchProvider :(WRLDSearchProviderHandle *) searchProvider
{
    [m_searchResultsViewController displayResultsFrom: searchProvider];
}

- (void) stopDisplayingSearchProvider :(WRLDSearchProviderHandle *) searchProvider
{
    [m_searchResultsViewController stopDisplayingResultsFrom: searchProvider];
}

- (void) displaySuggestionProvider :(WRLDSuggestionProviderHandle *) suggestionProvider
{
    [m_suggestionsViewController displayResultsFrom: suggestionProvider];
}

- (void) stopDisplayingSuggestionProvider :(WRLDSuggestionProviderHandle *) suggestionProvider
{
    [m_suggestionsViewController stopDisplayingResultsFrom: suggestionProvider];
}

- (void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
{

}


@end

