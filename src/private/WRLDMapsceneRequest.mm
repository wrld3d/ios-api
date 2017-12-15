#include "WRLDMapsceneRequest+Private.h"
#include "WRLDMapsceneRequest.h"
#include "WRLDMapsceneRequestOptions.h"
#include "EegeoMapsceneApi.h"
#include "Mapscene.h"

@interface WRLDMapsceneRequest ()

@end

@implementation WRLDMapsceneRequest
{
    Eegeo::Api::EegeoMapsceneApi* m_mapsceneApi;
    Eegeo::Mapscenes::MapsceneRequestId m_requestId;
}

-(instancetype)initWithMapsceneApi:(Eegeo::Api::EegeoMapsceneApi*)mapsceneApi :(WRLDMapsceneRequestOptions *)mapsceneRequestOptions
{
    self = [super init];
    
    if(self)
    {
        m_mapsceneApi = mapsceneApi;
        m_requestId = (Eegeo::Mapscenes::MapsceneRequestId)m_mapsceneApi->LoadMapscene(std::string([mapsceneRequestOptions.shortLinkUrl UTF8String]), mapsceneRequestOptions.applyMapsceneOnSuccess);
    }
    
    return self;
}

-(void)cancel
{
    m_mapsceneApi->CancelRequest(m_requestId);
}

@end
