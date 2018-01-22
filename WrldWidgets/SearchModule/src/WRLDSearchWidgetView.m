#import "WRLDSearchWidgetView.h"
#import "WRLDSearchWidgetViewController.h"
#import "WRLDSearchWidgetSearchBarDelegate.h"
#import "WRLDMapView.h"

@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *wrldSearchWidgetRootView;
@property (weak, nonatomic) IBOutlet UIButton *wrldSearchWidgetMenuButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *wrldSearchWidgetSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetTableView;
@end

@implementation WRLDSearchWidgetView
{
    WRLDSearchWidgetSearchBarDelegate *m_concreteDelegate;
}

-(id<UISearchBarDelegate>) getSearchBarDelegate
{
    return m_concreteDelegate;
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
    m_concreteDelegate = [WRLDSearchWidgetSearchBarDelegate alloc];
    
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    
    [widgetsBundle.self loadNibNamed:@"WRLDSearchWidgetView" owner:self options:nil];
    
    [self addSubview:self.wrldSearchWidgetRootView];
    
    self.wrldSearchWidgetRootView.frame = self.bounds;
    
    // assigns cancel button image in searchbar
//    UIImage *imgClear = [UIImage imageNamed:@"icon1_pin@3x.png" inBundle: widgetsBundle compatibleWithTraitCollection:nil];
//    [_wrldSearchWidgetSearchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    self.wrldSearchWidgetSearchBar.delegate = m_concreteDelegate;
}

-(void) assignWRLDSearchWidgetViewController: (WRLDSearchWidgetViewController *) searchWidgetViewController
{
    [searchWidgetViewController assignSearchBarDelegate: self.wrldSearchWidgetSearchBar];
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

