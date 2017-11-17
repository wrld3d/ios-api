
#import "WRLDSearchWidgetView.h"

@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *optionButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)optionClicked:(id)sender;

@end


@implementation WRLDSearchWidgetView


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self customInit];
    }
    
    return self;
}

-(void)customInit{
    //NSString* mainBundlePath = [[NSBundle mainBundle]bundlePath];
 
    //NSString* frameworkBundlePath = [[[NSBundle mainBundle] builtInPlugInsPath] @"WrldWidgets.bundle"];
    //NSBundle* frameworkBundle = [NSBundle bundleWithPath:@"/Library/WrldWidgets.bundle"];
    
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    
    [widgetsBundle.self loadNibNamed:@"WRLDSearchWidgetView" owner:self options:nil];
    
    [self addSubview:self.rootView];
    
    self.rootView.frame = self.bounds;
}


-(void)setSearchModule:(WRLDSearchModule*) searchModule{
    [_tableView setDataSource:searchModule];
    [_tableView setDelegate: searchModule];
    [self onResultsModelUpdate];
    [searchModule addUpdateDelegate: self];
}


-(void) onResultsModelUpdate
{
    [_tableView reloadData];
}

- (IBAction)optionClicked:(id)sender {
}
@end
