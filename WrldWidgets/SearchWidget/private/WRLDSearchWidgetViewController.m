#import "WRLDSearchWidgetViewController.h"
#import "WRLDSearchBar.h"
#import "WRLDSearchProviderHandle.h"
#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSearchWidgetTableViewController.h"
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchModel.h"
#import "WRLDSearchModelQueryDelegate.h"
#import "WRLDQueryFinishedViewUpdateDelegate.h"

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
    [m_searchModel getSuggestionsForString: searchText];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [m_searchModel getSearchResultsForString: searchBar.text];
}

- (void) initialiseSearchResultsTableViewWithResourcesFrom :(NSBundle*) resourceBundle
{
    m_searchResultsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.resultsTableView
                                                                             defaultCellIdentifier:m_searchResultsTableViewDefaultCellStyleIdentifier
                                                                                  heightConstraint:self.resultsHeightConstraint];

    [self.resultsTableView registerNib:[UINib nibWithNibName: m_searchResultsTableViewDefaultCellStyleIdentifier bundle:resourceBundle]
                forCellReuseIdentifier: m_searchResultsTableViewDefaultCellStyleIdentifier];
    [self.resultsTableView registerNib:[UINib nibWithNibName:m_moreResultsCellStyleIdentifier bundle: resourceBundle]
                forCellReuseIdentifier: m_moreResultsCellStyleIdentifier];
    [self.resultsTableView registerNib:[UINib nibWithNibName:m_searchInProgressCellStyleIdentifier bundle: resourceBundle]
                forCellReuseIdentifier: m_searchInProgressCellStyleIdentifier];
    
    WRLDQueryFinishedViewUpdateDelegate * showSearchResults = [[WRLDQueryFinishedViewUpdateDelegate alloc] initWithDisplayer: m_searchResultsViewController];
    [m_searchModel.searchDelegate addQueryCompletedDelegate: showSearchResults];
}

- (void) initialiseSuggestionTableViewWithResourcesFrom :(NSBundle*) resourceBundle
{
    m_suggestionsViewController = [[WRLDSearchWidgetTableViewController alloc] initWithTableView: self.suggestionsTableView
                                                                           defaultCellIdentifier:m_suggestionsTableViewCellStyleIdentifier
                                                                                heightConstraint:self.suggestionsHeightConstraint];
    
    self.suggestionsTableView.sectionHeaderHeight = 0;
    self.suggestionsTableView.sectionFooterHeight = 0;
    
    UINib * nib = [UINib nibWithNibName: m_suggestionsTableViewCellStyleIdentifier bundle: resourceBundle];
    [self.suggestionsTableView registerNib:nib forCellReuseIdentifier: m_suggestionsTableViewCellStyleIdentifier];
    
    WRLDQueryFinishedViewUpdateDelegate * showSuggestions = [[WRLDQueryFinishedViewUpdateDelegate alloc] initWithDisplayer: m_suggestionsViewController];
    [m_searchModel.suggestionDelegate addQueryCompletedDelegate: showSuggestions];
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

