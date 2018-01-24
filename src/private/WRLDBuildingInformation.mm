#import "WRLDBuildingInformation.h"
#import "WRLDBuildingInformation+Private.h"

@interface WRLDBuildingInformation ()

@end

@implementation WRLDBuildingInformation
{
    NSString* m_buildingId;
    WRLDBuildingDimensions* m_buildingDimensions;
	NSMutableArray* m_contours;
}

- (instancetype) initWithBuildingId:(NSString*)buildingId
                buildingDimensions:(WRLDBuildingDimensions*)buildingDimensions
                          contours:(NSMutableArray*)contours;

{
    if (self = [super init])
    {
        m_buildingId = buildingId;
        m_buildingDimensions = buildingDimensions;
        m_contours = contours;
    }

    return self;
}

- (NSString*) buildingId
{
    return m_buildingId;
}

- (WRLDBuildingDimensions*) buildingDimensions
{
    return m_buildingDimensions;
}

- (NSMutableArray*) contours
{
    return m_contours;
}

@end
