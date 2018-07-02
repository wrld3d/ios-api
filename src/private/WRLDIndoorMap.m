#pragma


#import "WRLDIndoorMap.h"


@implementation WRLDIndoorMap

- (id) initWithId:(NSString *)indoorId name:(NSString *)name floors:(NSArray<WRLDIndoorMapFloor *> *)floors userData:(NSString *)userData
{
    _indoorId = indoorId;
    _name = name;
    _floors = floors;
    _userData = userData;
    return self;
}

@end


@implementation WRLDIndoorMapFloor

- (id) initWithId:(NSString *)floorId name:(NSString *)name floorIndex:(NSInteger)floorIndex floorNumber:(NSInteger)floorNumber
{
    _floorId = floorId;
    _name = name;
    _floorIndex = floorIndex;
    _floorNumber = floorNumber;
    return self;
}

@end
