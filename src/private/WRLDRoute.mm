#import "WRLDRoute.h"
#import "WRLDRoute+Private.h"

@interface WRLDRoute ()

@end

@implementation WRLDRoute
{
    NSMutableArray* m_sections;
    NSTimeInterval m_duration;
    CLLocationDistance m_distance;
}

- (instancetype)initWithSections:(NSMutableArray*)sections
                        duration:(NSTimeInterval)duration
                        distance:(CLLocationDistance)distance
{
    if (self = [super init])
    {
        m_sections = sections;
        m_duration = duration;
        m_distance = distance;
    }

    return self;
}

- (NSMutableArray*) sections
{
    return m_sections;
}

- (NSTimeInterval) duration
{
    return m_duration;
}

- (CLLocationDistance) distance
{
    return m_distance;
}

@end
