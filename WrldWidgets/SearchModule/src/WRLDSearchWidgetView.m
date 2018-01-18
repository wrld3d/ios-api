#import "WRLDSearchWidgetView.h"
#import "WRLDSearchModule.h"
#import "WRLDMapView.h"

@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *WRLDMenuButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;

@end


@implementation WRLDSearchWidgetView
{
    WRLDSearchModule *m_searchModule;
    WRLDMapView *m_mapView;
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
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    
    [widgetsBundle.self loadNibNamed:@"WRLDSearchWidgetView" owner:self options:nil];
    
    [self addSubview:self.rootView];
    
    self.rootView.frame = self.bounds;
    _searchBar.delegate=self;
    m_searchModule = nil;
    m_mapView = nil;
    
    UIImage *imgClear = [UIImage imageNamed:@"icon1_pin@3x.png" inBundle: widgetsBundle compatibleWithTraitCollection:nil];
    [_searchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    //[m_searchModule searchSuggestions:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[m_searchModule search:[_searchBar text]];
}

-(void)setSearchModule:(WRLDSearchModule*) searchModule
{
    [_tableView setDataSource: [searchModule getResultsTableViewDataSource]];
    [_tableView setDelegate: [searchModule getResultsTableViewDelegate]];
    [self dataDidChange];
    //[searchModule addSearchModuleDelegate: self];
    m_searchModule = searchModule;
}

- (void) setMapView: (WRLDMapView*) mapView
{
    m_mapView = mapView;
}

-(void) dataDidChange
{
    [_tableView reloadData];
}

@end

