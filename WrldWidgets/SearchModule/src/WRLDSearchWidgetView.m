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
    WRLDSearchResultSet * resultSet = [m_searchProviders addSearchProvider: searchProvider];
    [m_searchResultsTableViewController addResultSet: resultSet];
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Get Suggestions for %@", searchText);
    self.wrldSearchWidgetTableView.hidden = ([searchText length] == 0) ? YES : NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Get Search for %@", [searchBar text]);
    WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: [searchBar text] : [m_searchProviders count]];
    
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

- (void)adjustHeightOfTableview
{
    CGFloat height = self.wrldSearchWidgetTableView.contentSize.height;
    CGFloat maxHeight = self.wrldSearchWidgetTableView.superview.frame.size.height - self.wrldSearchWidgetTableView.frame.origin.y;
    
    if (height > maxHeight)
        height = maxHeight;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.wrldSearchWidgetTableView.frame;
        frame.size.height = height;
        self.wrldSearchWidgetTableView.frame = frame;
    }];
}

@end

