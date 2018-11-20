#import "WRLDIndoorMapEntity.h"
#import "WRLDIndoorMapEntity+Private.h"
#import "IndoorMapEntityModel.h"

@interface WRLDIndoorMapEntity ()

@end

@implementation WRLDIndoorMapEntity
{

}

- (instancetype) initWithIndoorMapEntityId:(NSString*)indoorMapEntityId
                          indoorMapFloorId:(NSInteger)indoorMapFloorId
                                coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        _indoorMapEntityId = indoorMapEntityId;
        _indoorMapFloorId = indoorMapFloorId;
        _coordinate = coordinate;
    }
    return self;
}

+ (WRLDIndoorMapEntity*) createWRLDIndoorMapEntity:(const std::string&) indoorMapEntityId_
                                  indoorMapFloorId:(int)indoorMapFloorId_
                                        coordinate:(const Eegeo::Space::LatLong&)coordinate_
{
    NSString* indoorMapEntityId = [NSString stringWithCString:indoorMapEntityId_.c_str() encoding:NSUTF8StringEncoding];
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(coordinate_.GetLatitudeInDegrees(), coordinate_.GetLongitudeInDegrees());
    
    WRLDIndoorMapEntity* indoorMapEntity = [[WRLDIndoorMapEntity alloc] initWithIndoorMapEntityId:indoorMapEntityId
                                                                                 indoorMapFloorId:indoorMapFloorId_
                                                                                       coordinate:locationCoordinate];
    return indoorMapEntity;
}


@end
