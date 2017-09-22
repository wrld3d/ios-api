#import "WRLDIndoorControlView.h"
#import "IndoorControl.h"
#import "IndoorControlDelegate.h"


@interface WRLDIndoorControlView () <IndoorControlDelegate>

@property (nonatomic) IndoorControl* pIndoorControl;

- (void) onCancelButtonPressed;

@end

@implementation WRLDIndoorControlView

- (instancetype)initWithCoder:(NSCoder*)coder
{
    if(self = [super initWithCoder:coder])
    {
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initView];
    }
    
    return self;
}

- (void) initView
{
    self.backgroundColor = [UIColor clearColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.pIndoorControl = [[IndoorControl alloc] initWithParams: screenSize.width : screenSize.height andDelegate: self];
    [self addSubview:self.pIndoorControl];
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self)
    {
        return nil;
    }
    
    return hitView;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) dealloc
{
    [self removeObservers];
}

- (void) addObservers
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didEnterIndoorMap)
               name:WRLDMapViewDidEnterIndoorMapNotification object:_mapView];
    [center addObserver:self selector:@selector(didExitIndoorMap)
               name:WRLDMapViewDidExitIndoorMapNotification object:_mapView];
}

- (void) removeObservers
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:WRLDMapViewDidEnterIndoorMapNotification object:_mapView];
    [center removeObserver:self name:WRLDMapViewDidExitIndoorMapNotification object:_mapView];
}

- (void) setMapView:(WRLDMapView *)mapView
{
    if (_mapView != mapView)
    {
        if (_mapView)
        {
            [self removeObservers];
        }
        
        _mapView = mapView;
        
        if (_mapView)
        {
            [self addObservers];
        }
    }
}

- (void) didEnterIndoorMap
{
    [self showIndoorMapSlider];
}

- (void) didExitIndoorMap
{
    [self hideIndoorMapSlider];
}

- (void) showIndoorMapSlider
{
    if ([_mapView isIndoors])
    {
        [self.pIndoorControl setFullyOnScreen];
        [self.pIndoorControl setTouchEnabled:YES];
        
        NSString* floorName = [[_mapView activeIndoorMap].floors[0] name];
        [_pIndoorControl setFloorName:floorName];
        
        NSMutableArray<NSString*>* floorNames = [NSMutableArray array];
        WRLDIndoorMap* indoorMap = [_mapView activeIndoorMap];
        for (WRLDIndoorMapFloor* floor in indoorMap.floors)
        {
            [floorNames addObject:floor.floorId];
        }
        
        [self.pIndoorControl updateFloors:floorNames withCurrentFloor:0];
    }
}

- (void) hideIndoorMapSlider
{
    [self.pIndoorControl setTouchEnabled:NO];
    [self.pIndoorControl setFullyOffScreen];
}


- (void) onCancelButtonPressed
{
    [_mapView exitIndoorMap];
}

- (void) onFloorSliderPressed
{
    [_mapView expandIndoorMapView];
}

- (void) onFloorSliderReleased:(int)floorIndex
{
    [_mapView setFloorByIndex:floorIndex];
    [_mapView collapseIndoorMapView];
}

- (void) onFloorSliderDragged:(float)floorInterpolation
{
    if ([_mapView activeIndoorMap] == nil)
    {
        return;
    }
    NSUInteger numberOfFloors = [[_mapView activeIndoorMap].floors count];
    float interpolation = floorInterpolation * (numberOfFloors - 1);
    int floorIndex = lroundf(interpolation);
    NSString* floorName = [[_mapView activeIndoorMap].floors[floorIndex] name];
    
    [_pIndoorControl setFloorName:floorName];
    [_pIndoorControl setSelectedFloor:floorIndex];
    [_mapView setFloorInterpolation:interpolation];
}

@end
