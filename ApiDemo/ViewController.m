#import "ViewController.h"
@import Wrld;


@interface ViewController () <WRLDMapViewDelegate>


@property (nonatomic) IBOutlet WRLDMapView *mapView;


@end


@implementation ViewController
{
}

-(void)mapApiCreated
{
    NSLog(@"Eegeo Map api created");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_mapView)
    {
        _mapView = (WRLDMapView*)[self view];
    }
    
     _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}



- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (IBAction)exitButton:(id)sender
{
    [_mapView exitIndoorMap];
}

- (IBAction)moveUpButton:(id)sender
{
    [_mapView moveUpFloor];
}

- (IBAction)moveDownButton:(id)sender
{
    [_mapView moveDownFloor];
}

- (IBAction)expandButton:(id)sender
{
    [_mapView expandIndoorMapView];
}

- (IBAction)collapseButton:(id)sender
{
    [_mapView collapseIndoorMapView];
}

- (IBAction)enterButton:(id)sender
{
    [_mapView enterIndoorMap:@"westport_house"];
}

@end
