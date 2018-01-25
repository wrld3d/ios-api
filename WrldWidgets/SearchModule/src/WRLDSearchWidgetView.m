#import "WRLDSearchWidgetView.h"
#import "WRLDMapView.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchQuery.h"
#import "SearchProviders.h"
#import "WRLDSearchResultTableViewController.h"
#import "WRLDSearchResultSet.h"


@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *wrldSearchWidgetRootView;
@property (weak, nonatomic) IBOutlet UIButton *wrldSearchWidgetMenuButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *wrldSearchWidgetSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation WRLDSearchWidgetView
{
    id<WRLDSearchDelegate> m_wrldSearchDelegate;
    SearchProviders* m_searchProviders;
    WRLDSearchResultTableViewController* m_searchResultsTableViewController;
    bool m_isAnimatingOut;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
        m_isAnimatingOut = false;
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
    [self assignSearchDelegate: m_searchProviders];
    
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    
    [widgetsBundle.self loadNibNamed:@"WRLDSearchWidgetView" owner:self options:nil];
    
    m_searchResultsTableViewController = [[WRLDSearchResultTableViewController alloc] init: self.wrldSearchWidgetTableView : m_searchProviders];
    
    [self addSubview:self.wrldSearchWidgetRootView];
    
    self.wrldSearchWidgetRootView.frame = self.bounds;
    
    self.wrldSearchWidgetTableView.dataSource = m_searchResultsTableViewController;
    self.wrldSearchWidgetTableView.delegate = m_searchResultsTableViewController;
    [m_searchResultsTableViewController setHeightConstraint: self.heightConstraint];
    
    self.wrldSearchWidgetTableView.sectionFooterHeight = 0;
    
    // assigns cancel button image in searchbar
//    UIImage *imgClear = [UIImage imageNamed:@"icon1_pin@3x.png" inBundle: widgetsBundle compatibleWithTraitCollection:nil];
//    [_wrldSearchWidgetSearchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
}

-(void) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    [m_searchProviders addSearchProvider: searchProvider];
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Get Suggestions for %@", searchText);
    if([searchText length] == 0 && !m_isAnimatingOut)
    {
        m_isAnimatingOut = true;
        [UIView animateWithDuration: 0.25 animations:^{
            self.wrldSearchWidgetTableView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if(finished){
                self.wrldSearchWidgetTableView.hidden =  YES;
                NSLog(@"self.wrldSearchWidgetTableView.hidden");
                m_isAnimatingOut = false;
            }
        }];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Get Search for %@", [searchBar text]);
    WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: [searchBar text] : m_searchProviders];
    
    [m_searchResultsTableViewController setCurrentQuery:newQuery];
    [m_wrldSearchDelegate doSearch: newQuery];
}

-(void)assignSearchDelegate: (id<WRLDSearchDelegate>) wrldSearchDelegate
{
    m_wrldSearchDelegate = wrldSearchDelegate;
}

-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
{
    [self.wrldSearchWidgetTableView registerNib:nib forCellReuseIdentifier: cellIdentifier];
}

@end

