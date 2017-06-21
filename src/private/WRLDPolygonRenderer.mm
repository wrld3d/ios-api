
#import "WRLDMapView.h"
#import "WRLDPolygonRenderer.h"
#import "WRLDPolygon.h"


@implementation WRLDOverlayRenderer

@synthesize overlay;

- (instancetype)initWithOverlay:(id <WRLDOverlay>)overlay_
{
    self = [super init];
    overlay = overlay_;
    return self;
}


@end


@interface WRLDPolygonRenderer ()


@property (nonatomic, readwrite) WRLDPolygon *polygon;

@end

@implementation WRLDPolygonRenderer
{

}




- (instancetype)initWithPolygon:(WRLDPolygon *)polygon;
{
    self = [super initWithOverlay:polygon];
    _polygon = polygon;
    return self;
}

@end
