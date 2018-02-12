#import "WRLDSearchWidgetViewController.h"
#import "WRLDSearchBar.h"
#import "WRLDSearchProviderHandle.h"
#import "WRLDSuggestionProviderHandle.h"

@interface WRLDSearchWidgetViewController()
@property (unsafe_unretained, nonatomic) IBOutlet WRLDSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *resultsTableContainerView;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetResultsTableView;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetSuggestionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionsHeightConstraint;
@end

@implementation WRLDSearchWidgetViewController
{
    WRLDSearchModel * m_searchModel;
}

-(instancetype) initWithSearchModel : (WRLDSearchModel *) searchModel
{
    NSBundle* bundle = [NSBundle bundleForClass:[WRLDSearchWidgetViewController class]];
    self = [super initWithNibName: @"WRLDSearchWidget" bundle:bundle];
    if(self)
    {
        m_searchModel = searchModel;
    }
    return self;
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setActive: true];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setActive: false];
}

-(void) displaySearchProvider :(WRLDSearchProviderReference*) searchProvider
{
    
}

-(void) displaySuggestionProvider :(WRLDSuggestionProviderHandle*) suggestionProvider
{
    
}

-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
{

}
@end

