#import "WRLDRouteDirections.h"
#import "WRLDRouteDirections+Private.h"

@interface WRLDRouteDirections ()

@end

@implementation WRLDRouteDirections
{
    NSString* m_type;
    NSString* m_modifier;
    CLLocationCoordinate2D m_latLng;
    CLLocationDirection m_headingBefore;
	CLLocationDirection m_headingAfter;

}

- (instancetype)initWithType:(NSString*)type
                    modifier:(NSString*)modifier
                      latLng:(CLLocationCoordinate2D)latLng
               headingBefore:(CLLocationDirection)headingBefore
                headingAfter:(CLLocationDirection)headingAfter
{
    if (self = [super init])
    {
        m_type = type;
        m_modifier = modifier;
        m_latLng = latLng;
        m_headingBefore = headingBefore;
        m_headingAfter = headingAfter;
    }

    return self;
}

- (NSString*) type
{
    return m_type;
}

- (NSString*) modifier
{
    return m_modifier;
}

- (CLLocationCoordinate2D) latLng
{
    return m_latLng;
}

- (CLLocationDirection) headingBefore
{
    return m_headingBefore;
}

- (CLLocationDirection) headingAfter
{
    return m_headingAfter;
}

@end
