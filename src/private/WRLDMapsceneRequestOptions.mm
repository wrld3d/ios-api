#include "WRLDMapsceneRequestOptions.h"

@interface WRLDMapsceneRequestOptions()

@end

@implementation WRLDMapsceneRequestOptions

-(instancetype)initWithShortLink:(NSString*)shortLinkUrl applyMapsceneOnSuccess:(bool)applyMapsceneOnSuccess
{
    
    self = [super init];
    
    if(self)
    {
        _shortLinkUrl = shortLinkUrl;
        _applyMapsceneOnSuccess = applyMapsceneOnSuccess;
    }
    
    return self;
}


@end
