#import "WRLDRouteSection.h"
#import "WRLDRouteSection+Private.h"

@interface WRLDRouteSection ()

@end

@implementation WRLDRouteSection
{
    NSMutableArray* m_steps;
    NSTimeInterval m_duration;
    CLLocationDistance m_distance;
}

- (instancetype)initWithSteps:(NSMutableArray*)steps
                     duration:(NSTimeInterval)duration
                     distance:(CLLocationDistance)distance
{
    if (self = [super init])
    {
        m_steps = steps;
        m_duration = duration;
        m_distance = distance;
    }

    return self;
}

- (NSMutableArray*) steps
{
    return m_steps;
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
