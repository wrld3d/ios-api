#import "WRLDMarkerOptions.h"

@interface WRLDMarkerOptions ()

@property (nonatomic, readwrite) NSString* indoorMapId;

@property (nonatomic, readwrite) NSInteger indoorFloorId;

@end

@implementation WRLDMarkerOptions

+ (instancetype)markerOptions
{
    return [[self alloc] initProperties];
}

- (instancetype)initProperties
{
    if (self = [super init])
    {
        _title = @"";
        _styleName = @"marker_default";
        _userData = @"";
        _iconKey = @"misc";
    }
    return self;
}

- (void)setIndoorMapId:(NSString *)indoorMapId
            andFloorId:(NSInteger)floorId
{
    _indoorMapId = indoorMapId;
    _indoorFloorId = floorId;
}


@end
