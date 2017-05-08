#import "ViewController.h"
#import "AppMapViewDelegate.h"
@import Wrld;


@interface ViewController () <WRLDMapViewDelegate>


@property (nonatomic) IBOutlet WRLDMapView *mapView;


@property (nonatomic) AppMapViewDelegate *mapViewDelegate;

@end


@implementation ViewController
{
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_mapView)
    {
        _mapView = (WRLDMapView*)[self view];
    }
    
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _mapViewDelegate = _mapView.delegate ? _mapView.delegate : [AppMapViewDelegate alloc];

    _mapView.delegate = _mapViewDelegate;
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(56.4599662, -2.9781313)
                        zoomLevel:15
                         animated:NO];
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

#pragma mark - AppMapViewDelegate

- (void)initialMapSceneLoaded:(WRLDMapView *)mapView
{
    NSLog(@"ViewController - streaming of initial map scene completed.");

}

@end
