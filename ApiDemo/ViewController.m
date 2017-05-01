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
    
    const double latitude = 37.802;
    const double longitude = -122.405783;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    
    [_mapView setCenterCoordinate:coord
                         animated:true];
}



- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end
