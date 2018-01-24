#import "WRLDBuildingHighlight.h"
#import "WRLDBuildingHighlight+Private.h"
#import "WRLDBuildingHighlightOptions+Private.h"
#import "WRLDBuildingApiHelpers.h"
#import "WRLDMathApiHelpers.h"

#import "BuildingInformation.h"

@interface WRLDBuildingHighlight ()

@end

@implementation WRLDBuildingHighlight
{
    int m_buildingHighlightId;
    Eegeo::Api::EegeoBuildingsApi* m_buildingsApi;
    UIColor* m_color;
    WRLDBuildingInformation* m_buildingInformation;
}

- (instancetype) initWithApi:(Eegeo::Api::EegeoBuildingsApi&)buildingsApi
    buildingHighlightOptions:(WRLDBuildingHighlightOptions*)buildingHighlightOptions
{
    if (self = [super init])
    {
        m_buildingsApi = &buildingsApi;
        m_color = [buildingHighlightOptions color];

        m_buildingHighlightId = m_buildingsApi->CreateHighlight([WRLDBuildingApiHelpers createBuildingHighlightCreateParams:buildingHighlightOptions]);
        m_buildingInformation = nil;
    }

    return self;
}

- (void) destroy
{
    m_buildingsApi->DestroyHighlight(m_buildingHighlightId);
}

- (int) buildingHighlightId
{
    return m_buildingHighlightId;
}

- (UIColor*) color
{
    return m_color;
}

- (void) setColor:(UIColor*)color
{
    m_color = color;

    m_buildingsApi->SetHighlightColor(m_buildingHighlightId, [WRLDMathApiHelpers getEegeoColor:m_color]);
}

- (nullable WRLDBuildingInformation*) buildingInformation
{
    return m_buildingInformation;
}

- (void)loadBuildingInformationFromNative
{
    if (m_buildingsApi->IsBuildingInformationResolved(m_buildingHighlightId))
    {
        const Eegeo::BuildingHighlights::BuildingInformation& buildingInformation = m_buildingsApi->GetBuildingInformation(m_buildingHighlightId);
        m_buildingInformation = [WRLDBuildingApiHelpers createWRLDBuildingInformation:buildingInformation];
    }
}

@end
