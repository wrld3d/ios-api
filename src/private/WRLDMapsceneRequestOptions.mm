#include "WRLDMapsceneRequestOptions.h"

@interface WRLDMapsceneRequestOptions()

@end

@implementation WRLDMapsceneRequestOptions{
    NSString* m_shortLinkUrl;
    bool m_applyMapsceneOnSuccess;
}

-(instancetype)initMapsceneRequestOptions :(NSString*)shortLinkUrl :(bool)applyMapsceneOnSuccess{
    
    self = [super init];
    
    if(self){
        m_shortLinkUrl = shortLinkUrl;
        m_applyMapsceneOnSuccess = applyMapsceneOnSuccess;
    }
    
    return self;
}

-(NSString*)getShortLinkUrl{
    return m_shortLinkUrl;
}

-(bool)getApplyMapsceneOnSuccess{
    return m_applyMapsceneOnSuccess;
}

@end
