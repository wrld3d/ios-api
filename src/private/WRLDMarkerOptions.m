#import "WRLDMarkerOptions.h"

@interface WRLDMarkerOptions ()

@property (nonatomic, readwrite) NSString* indoorMapId;

@property (nonatomic, readwrite) NSInteger indoorFloorId;

@end

@implementation WRLDMarkerOptions

+ (instancetype)markerOptions
{
    return [[self alloc] init];
}

- (void)setIndoorMapId:(NSString *)indoorMapId
            andFloorId:(NSInteger)floorId
{
    _indoorMapId = indoorMapId;
    _indoorFloorId = floorId;
}


@end
