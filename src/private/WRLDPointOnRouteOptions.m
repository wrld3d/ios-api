#import "WRLDPointOnRouteOptions.h"
#import "WRLDPointOnRouteOptions+Private.h"

@interface WRLDPointOnRouteOptions ()

@end

@implementation WRLDPointOnRouteOptions
{
    NSString* m_indoorMapId;
    NSInteger m_indoorMapFloorId;
}

- (instancetype)init
{
    if (self = [super init])
    {
        m_indoorMapId = @"";
        m_indoorMapFloorId = 0;
    }
    
    return self;
}

- (WRLDPointOnRouteOptions*) indoorMapId:(NSString*)indoorMapId
{
    m_indoorMapId = indoorMapId;
    return self;
}

- (WRLDPointOnRouteOptions*) indoorMapFloorId:(NSInteger)indoorMapFloorId
{
    m_indoorMapFloorId = indoorMapFloorId;
    return self;
}

- (NSString*) getIndoorMapId
{
    return m_indoorMapId;
}

- (NSInteger) getIndoorMapFloorId
{
    return m_indoorMapFloorId;
}

@end
