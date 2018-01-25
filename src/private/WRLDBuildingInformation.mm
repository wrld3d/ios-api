#import "WRLDBuildingInformation.h"
#import "WRLDBuildingInformation+Private.h"

@interface WRLDBuildingInformation ()

@end

@implementation WRLDBuildingInformation
{

}

- (instancetype) initWithBuildingId:(NSString*)buildingId
                buildingDimensions:(WRLDBuildingDimensions*)buildingDimensions
                          contours:(NSArray<WRLDBuildingContour*>*)contours;

{
    if (self = [super init])
    {
        _buildingId = buildingId;
        _buildingDimensions = buildingDimensions;
        _contours = contours;
    }

    return self;
}

@end
