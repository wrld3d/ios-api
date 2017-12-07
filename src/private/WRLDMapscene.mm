#include "WRLDMapscene.h"
#include "WRLDMapsceneStartLocation.h"

@interface WRLDMapscene()

@end

@implementation WRLDMapscene{
    NSString* m_name;
    NSString* m_shortLink;
    NSString* m_apiKey;
    WRLDMapsceneStartLocation* m_wrldMapsceneStartLocation;
}

-(NSString*)getName{
    return m_name;
}
-(NSString*)getShortLink{
    return m_shortLink;
}
-(NSString*)getApiKey{
    return m_apiKey;
}
-(WRLDMapsceneStartLocation*)getWRLDMapsceneStartLocation{
    return m_wrldMapsceneStartLocation;
}


-(void)setName:(NSString*)name{
    m_name = name;
}
-(void)setShortLink:(NSString*)shortLink{
m_shortLink=shortLink;
}
-(void)setApiKey:(NSString*)apiKey{
    m_apiKey=apiKey;
}
-(void)setWRLDMapsceneStartLocation:(WRLDMapsceneStartLocation*)wrldMapsceneStartLocation{
    m_wrldMapsceneStartLocation = wrldMapsceneStartLocation;
}

@end
