
#import "WRLDSearchWidgetView.h"
#import "WRLDSearchResultView.h"
#import "WRLDSearchSuggestionView.h"

@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *WRLDMenuButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)WRLDButtonClicked:(id)sender;

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
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    [m_searchModule searchSuggestions:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [m_searchModule search:[_searchBar text]];
}

-(void)setSearchModule:(WRLDSearchModule*) searchModule
{
    [_tableView setDataSource:searchModule];
    [_tableView setDelegate: searchModule];
    [self dataDidChange];
    [searchModule addSearchModuleDelegate: self];
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

- (void)didSelectResult:(WRLDSearchResult *)searchResult
{
    if(m_mapView != nil)
    {
      [m_mapView setCenterCoordinate:[searchResult latLng]
                            animated:NO];
    }
}

- (IBAction)WRLDButtonClicked:(id)sender {
    //Open The menu
}

- (UITableViewCell*) createTableViewCellForSearch: (UITableView*)tableView cellIndexPath: (NSIndexPath*)indexPath searchResult: (WRLDSearchResult*)searchResult
{
    // Default search/suggestion result views
    if([searchResult type] == WRLDResult)
    {
        WRLDSearchResultView* cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"genericResultCell"];
        
        if(cell == nil)
        {
            NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchResultView class]];
            
            [tableView registerNib:[UINib nibWithNibName:@"WRLDGenericSearchResultView" bundle:widgetsBundle] forCellReuseIdentifier:@"genericResultCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"genericResultCell" forIndexPath:indexPath];
        }

        [cell.titleLabel setText:[searchResult title]];
        [cell.descriptionLabel setText:[searchResult subTitle]];
        
        if([searchResult tags] != nil && [[searchResult tags] length] > 0)
        {
            [cell.tagsIcon setHidden:NO];
            [cell.tagsLabel setText:[[searchResult tags] stringByReplacingOccurrencesOfString:@" " withString:@", "]];
        }
        else
        {
            [cell.tagsIcon setHidden:YES];
            [cell.tagsLabel setText:@""];
        }
        
        // todo - Fetch icon from URL using iconkey as lookup
        //[cell.iconImage setImage:];
        
        return cell;
    }
    else if([searchResult type] == WRLDSuggestion)
    {
        WRLDSearchSuggestionView* cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"genericSuggestionCell"];
        
        if(cell == nil)
        {
            NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchSuggestionView class]];
            
            [tableView registerNib:[UINib nibWithNibName:@"WRLDGenericSearchSuggestionView" bundle:widgetsBundle] forCellReuseIdentifier:@"genericSuggestionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"genericSuggestionCell" forIndexPath:indexPath];
        }

        [cell.titleLabel setText:[searchResult title]];

        // todo - Fetch icon from URL using iconkey as lookup
        //[cell.iconImage setImage:];
        
        return cell;
    }
    return nil;
}

@end
