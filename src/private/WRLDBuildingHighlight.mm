#import "WRLDBuildingHighlight.h"
#import "WRLDBuildingHighlight+Private.h"
#import "WRLDBuildingHighlightOptions+Private.h"
#import "WRLDBuildingApiHelpers.h"
#import "WRLDMathApiHelpers.h"
#import "WRLDOverlayImpl.h"

#import "BuildingInformation.h"
#import "EegeoBuildingsApi.h"
#import "EegeoMapApi.h"

@interface WRLDBuildingHighlight () <WRLDOverlayImpl>

@end

@implementation WRLDBuildingHighlight
{
    Eegeo::Api::EegeoBuildingsApi* m_pBuildingsApi;
    int m_buildingHighlightId;
    WRLDBuildingHighlightOptions* m_buildingHighlightOptions;
}

+ (instancetype)highlightWithOptions:(WRLDBuildingHighlightOptions*)highlightOptions
{
    return [[self alloc] initWithHighlightOptions:highlightOptions];
}

- (instancetype) initWithHighlightOptions:(WRLDBuildingHighlightOptions*)buildingHighlightOptions
{
    if (self = [super init])
    {
        m_buildingHighlightOptions = buildingHighlightOptions;
        _color = [buildingHighlightOptions color];
        _buildingInformation = nil;
        
        m_pBuildingsApi = nil;
    }

    return self;
}

- (int) buildingHighlightId
{
    return m_buildingHighlightId;
}

- (UIColor*) _getColor
{
    return _color;
}

- (void) setColor:(UIColor*)color
{
    _color = color;
    if (![self nativeCreated])
    {
        return;
    }
    m_pBuildingsApi->SetHighlightColor(m_buildingHighlightId, [WRLDMathApiHelpers getEegeoColor:_color]);
}

- (void)loadBuildingInformationFromNative
{
    if (![self nativeCreated])
    {
        return;
    }

    if (m_pBuildingsApi->IsBuildingInformationResolved(m_buildingHighlightId))
    {
        const Eegeo::BuildingHighlights::BuildingInformation& buildingInformation = m_pBuildingsApi->GetBuildingInformation(m_buildingHighlightId);
        _buildingInformation = [WRLDBuildingApiHelpers createWRLDBuildingInformation:buildingInformation];
    }
}

#pragma mark - WRLDOverlayImpl (Private)

- (void)createNative:(Eegeo::Api::EegeoMapApi&) mapApi
{
    if ([self nativeCreated])
        return;

    m_pBuildingsApi = &mapApi.GetBuildingsApi();
    m_buildingHighlightId = m_pBuildingsApi->CreateHighlight([WRLDBuildingApiHelpers createBuildingHighlightCreateParams:m_buildingHighlightOptions]);
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pBuildingsApi != nullptr)
    {
        m_pBuildingsApi->DestroyHighlight(m_buildingHighlightId);
        m_pBuildingsApi = nullptr;
        m_buildingHighlightId = 0;
        _buildingInformation = nullptr;
        m_buildingHighlightOptions = nullptr;
    }
}

- (WRLDOverlayId)getOverlayId
{
    return { WRLDOverlayBuildingHighlight, m_buildingHighlightId };
}

- (bool)nativeCreated
{
    return m_buildingHighlightId != 0;
}

@end
