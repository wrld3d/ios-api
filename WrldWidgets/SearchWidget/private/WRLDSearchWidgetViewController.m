#import "WRLDSearchWidgetViewController.h"
#import "WRLDSearchWidgetSearchBar.h"

@interface WRLDSearchWidgetViewController()
@property (unsafe_unretained, nonatomic) IBOutlet WRLDSearchWidgetSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *resultsTableContainerView;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetResultsTableView;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetSuggestionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionsHeightConstraint;
@end

@implementation WRLDSearchWidgetViewController

-(instancetype) init
{
    NSBundle* bundle = [NSBundle bundleForClass:[WRLDSearchWidgetViewController class]];
    self = [super initWithNibName: @"WRLDSearchWidget" bundle:bundle];
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

//-(void) addSearchProvider :(id<WRLDSearchProvider>) searchProvider
//{
//    
//}
//
//-(void) addSuggestionProvider :(id<WRLDSuggestionProvider>) suggestionProvider
//{
//    
//}
//
//-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
//{
//
//}
@end

