#import "WRLDIndoorMapEntityInformation.h"
#import "WRLDIndoorMapEntityInformation+Private.h"
#import "WRLDIndoorMapEntity+Private.h"
#import "WRLDMathApiHelpers.h"
#import "WRLDOverlayImpl.h"

#import "IndoorMapEntityModel.h"
#import "EegeoIndoorEntityInformationApi.h"

#import "EegeoMapApi.h"

@interface WRLDIndoorMapEntityInformation () <WRLDOverlayImpl>

@end

@implementation WRLDIndoorMapEntityInformation
{
    Eegeo::Api::EegeoIndoorEntityInformationApi* m_pIndoorEntityInformationApi;
    int m_indoorMapEntityInformationId;
}

+ (instancetype)informationForIndoorMap:(NSString *)indoorMapId
{
    return [[self alloc] initWithIndoorMapId:indoorMapId];
}

- (instancetype) initWithIndoorMapId:(NSString*)indoorMapId
{
    if (self = [super init])
    {
        _indoorMapId = indoorMapId;
        _indoorMapEntities = nil;
        
        m_pIndoorEntityInformationApi = nil;
    }

    return self;
}

- (int) indoorMapEntityInformationId
{
    return m_indoorMapEntityInformationId;
}

- (NSString*) _getIndoorMapId
{
    return _indoorMapId;
}


- (void)loadIndoorMapEntityInformationFromNative
{
    if (![self nativeCreated])
    {
        return;
    }

    const auto& entityModelIds = m_pIndoorEntityInformationApi->GetEntityModelIdsForInformationId(m_indoorMapEntityInformationId);

    NSMutableArray* indoorMapEntities = [[NSMutableArray alloc] initWithCapacity:entityModelIds.size()];
    
    for (const auto& entityModelId : entityModelIds)
    {
        const auto& indoorMapEntityId = m_pIndoorEntityInformationApi->GetIndoorMapEntityId(entityModelId);
        const auto& floorId = m_pIndoorEntityInformationApi->GetIndoorMapEntityFloorId(entityModelId);
        const auto& coordinate = m_pIndoorEntityInformationApi->GetIndoorMapEntityCoordinate(entityModelId);

        WRLDIndoorMapEntity* indoorMapEntity = [WRLDIndoorMapEntity createWRLDIndoorMapEntity:indoorMapEntityId
                                                                             indoorMapFloorId:floorId
                                                                                   coordinate:coordinate ];

        [indoorMapEntities addObject:indoorMapEntity];
    }
    
    _indoorMapEntities = [indoorMapEntities copy];
    _loadState = static_cast<WRLDIndoorMapEntityLoadState>(m_pIndoorEntityInformationApi->GetIndoorMapEntityLoadState(m_indoorMapEntityInformationId));
}

#pragma mark - WRLDOverlayImpl (Private)

- (void)createNative:(Eegeo::Api::EegeoMapApi&) mapApi
{
    if ([self nativeCreated])
        return;

    m_pIndoorEntityInformationApi = &mapApi.GetIndoorEntityInformationApi();
    m_indoorMapEntityInformationId = m_pIndoorEntityInformationApi->CreateIndoorMapEntityInformation(std::string([_indoorMapId UTF8String]));
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pIndoorEntityInformationApi != nullptr)
    {
        m_pIndoorEntityInformationApi->DestroyIndoorMapEntityInformation(m_indoorMapEntityInformationId);
        m_pIndoorEntityInformationApi = nullptr;
        m_indoorMapEntityInformationId = 0;
        _indoorMapEntities = nullptr;
        _indoorMapId = nullptr;
    }
}

- (WRLDOverlayId)getOverlayId
{
    return { WRLDOverlayIndoorMapInformation, m_indoorMapEntityInformationId };
}

- (bool)nativeCreated
{
    return m_indoorMapEntityInformationId != 0;
}

@end
