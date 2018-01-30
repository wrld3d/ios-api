#import <QuartzCore/QuartzCore.h>

#import "WRLDSearchWidgetView.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchQuery.h"
#import "SearchProviders.h"
#import "WRLDSearchResultTableViewController.h"
#import "WRLDSearchSuggestionsViewController.h"
#import "WRLDSearchResult.h"
#import "WRLDSearchResultSet.h"


@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *wrldSearchWidgetRootView;
@property (weak, nonatomic) IBOutlet UIButton *wrldSearchWidgetMenuButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *wrldSearchWidgetSearchBar;
@property (weak, nonatomic) IBOutlet UIView *wrldSearchWidgetResultsTableViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetResultsTableView;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetSuggestionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionsHeightConstraint;
@end

@implementation WRLDSearchWidgetView
{
    SearchProviders* m_searchProviders;
    WRLDSearchResultTableViewController* m_searchResultsTableViewController;
    WRLDSearchSuggestionsViewController* m_searchSuggestionsTableViewController;
    bool m_byPassSuggestions;
    NSString* m_suggestionsText;
    CALayer *m_searchBarBorderObject;
    UIColor *m_searchBarActiveColor;
    UIImage * m_searchBarIcon;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

-(void)customInit
{
    m_searchProviders = [[SearchProviders alloc] init];
    m_byPassSuggestions = false;
    m_suggestionsText = @"";
    
    if (@available(iOS 9.0, *))
    {
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{
                                                                                                                     NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16],
                                                                                                                     }];
    }
    else
    {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
                                                                                                         NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16],
                                                                                                         }];
    }
    
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    
    [widgetsBundle.self loadNibNamed:@"WRLDSearchWidgetView" owner:self options:nil];
    
    [self addSubview:self.wrldSearchWidgetRootView];
    self.wrldSearchWidgetRootView.frame = self.bounds;
    
    m_searchResultsTableViewController = [[WRLDSearchResultTableViewController alloc] init:
                                          self.wrldSearchWidgetResultsTableViewContainer :
                                          self.wrldSearchWidgetResultsTableView :
                                          m_searchProviders :
                                          ^(WRLDSearchResult* result) {
                                              [self setQueryTextWithoutSuggestions: result.title];
                                          }];
    
    [m_searchResultsTableViewController setHeightConstraint: self.resultsHeightConstraint
                                                  maxHeight: self.bounds.size.height - self.wrldSearchWidgetSearchBar.bounds.size.height];
    
    m_searchSuggestionsTableViewController = [[WRLDSearchSuggestionsViewController alloc] init :
                                              self.wrldSearchWidgetSuggestionsTableView :
                                              m_searchProviders :
                                               ^(NSString* queryText) {
                                                   [self setQueryTextWithoutSuggestions: queryText];
                                                   [self runSearch: queryText];
                                               }];
    
    
    [m_searchSuggestionsTableViewController setHeightConstraint: self.suggestionsHeightConstraint];
    
//    UIImage *imgClear = [UIImage imageNamed:@"Expander.png" inBundle: widgetsBundle compatibleWithTraitCollection:nil];
//    [_wrldSearchWidgetSearchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    m_searchBarBorderObject = [self addBorderToSearchBar: self.wrldSearchWidgetSearchBar color:[UIColor grayColor]];
    
    m_searchBarActiveColor = [UIColor colorWithRed:0.0f/255.0f green:113.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
}

-(CALayer *) addBorderToSearchBar:(UISearchBar*) searchBar
                       color: (UIColor *) color
{    
    searchBar.layer.borderColor = [color CGColor];
    searchBar.layer.borderWidth = 1.0;
    searchBar.layer.cornerRadius = 10;
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    m_searchBarIcon = [searchBar imageForSearchBarIcon:
                       UISearchBarIconSearch state: UIControlStateNormal];
    return searchBar.layer;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if([self subviewContainsEvent: self.wrldSearchWidgetSearchBar point: point event: event]) return YES;
    if([self subviewContainsEvent: self.wrldSearchWidgetResultsTableViewContainer point: point event: event]) return YES;
    if([self subviewContainsEvent: self.wrldSearchWidgetSuggestionsTableView point: point event: event]) return YES;
    return NO;
}

-(BOOL) subviewContainsEvent: (UIView*) view
                       point: (CGPoint)point
                        event: (UIEvent*) event
{
    if (view.userInteractionEnabled && ![view  isHidden] && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
        return YES;
    }
    if([self.wrldSearchWidgetSearchBar isFirstResponder]){
        [self.wrldSearchWidgetSearchBar resignFirstResponder];
    }
    return NO;
}

-(void) setSearchBarBorderColor :(UIColor *) color
{
    m_searchBarBorderObject.borderColor = [color CGColor];
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setSearchBarBorderColor: m_searchBarActiveColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        [searchBar setPositionAdjustment:UIOffsetMake(-24, 0) forSearchBarIcon:UISearchBarIconSearch];
    }];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self setSearchBarBorderColor: [UIColor grayColor]];
    
    [UIView animateWithDuration:0.25 animations:^{
        [searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
    }];
}

- (void)dictationRecordingDidEnd
{
    [self runSearch:[self.wrldSearchWidgetSearchBar text]];
}

-(void) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    [m_searchProviders addSearchProvider: searchProvider];
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSString *trimmedString = [searchText stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if([trimmedString isEqualToString:m_suggestionsText]){
        return;
    }
    
    m_suggestionsText = trimmedString;
    
    if(!m_byPassSuggestions)
    {
        [m_searchResultsTableViewController fadeOut];
        
        if([searchText length] > 0)
        {
            WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: trimmedString : m_searchProviders];
            [m_searchSuggestionsTableViewController setCurrentQuery:newQuery];
            [m_searchProviders doSuggestions: newQuery];
        }
        else{
            [m_searchSuggestionsTableViewController fadeOut];
        }
    }
}

-(void) setQueryTextWithoutSuggestions: (NSString *) text
{
    m_byPassSuggestions = true;
    [self.wrldSearchWidgetSearchBar setText:text];
    m_byPassSuggestions = false;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self runSearch:[searchBar text]];
}

-(void) runSearch:(NSString *) queryString
{
    m_suggestionsText = queryString;
    [m_searchSuggestionsTableViewController fadeOut];
    WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString : m_searchProviders];
    
    [m_searchResultsTableViewController setCurrentQuery:newQuery];
    [m_searchProviders doSearch: newQuery];
    [self.wrldSearchWidgetSearchBar resignFirstResponder];
}

-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
{
    [self.wrldSearchWidgetResultsTableView registerNib:nib forCellReuseIdentifier: cellIdentifier];
}

@end

