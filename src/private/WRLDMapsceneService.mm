#import <Foundation/Foundation.h>

#include "WRLDMapsceneService+Private.h"
#include "EegeoMapsceneApi.h"
#include "WRLDMapsceneRequest+Private.h"
#include "WRLDMapsceneRequestOptions.h"

@interface WRLDMapsceneService()

@end

@implementation WRLDMapsceneService
{
    Eegeo::Api::EegeoMapsceneApi* m_mapsceneApi;
}

-(instancetype)initWithApi:(Eegeo::Api::EegeoMapsceneApi&)mapsceneApi
{
    if (self = [super init])
    {
        m_mapsceneApi = &mapsceneApi;
    }
    
    return self;
}

-(WRLDMapsceneRequest*)RequestMapscene :(WRLDMapsceneRequestOptions*)mapsceneRequestOptions
{
    
    WRLDMapsceneRequest* m_mapsceneRequest = [[WRLDMapsceneRequest alloc] initWithMapsceneApi:m_mapsceneApi :mapsceneRequestOptions];
    
    return m_mapsceneRequest;
}

@end
