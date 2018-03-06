#import "WRLDIndoorEntityHighlight.h"
#import "WRLDIndoorEntityHighlight+Private.h"
#import "WRLDStringApiHelpers.h"
#import "WRLDMathApiHelpers.h"
#import "WRLDOverlayImpl.h"

#import "EegeoIndoorEntityApi.h"
#import "EegeoMapApi.h"

@interface WRLDIndoorEntityHighlight () <WRLDOverlayImpl>

@end

@implementation WRLDIndoorEntityHighlight
{
    Eegeo::Api::EegeoIndoorEntityApi* m_pIndoorEntityApi;
    std::string m_indoorEntityId;
    std::string m_indoorMapId;
    int m_indoorHighlightId;
}

+ (instancetype)indoorEntityHighlightWithId:(NSString*)indoorEntityId
                                indoorMapId:(NSString*)indoorMapId
                                      color:(UIColor*)color
{
    return [[self alloc] initWithId:indoorEntityId
                        indoorMapId:indoorMapId
                              color:color];
}

- (instancetype)initWithId:(NSString*)indoorEntityId
               indoorMapId:(NSString*)indoorMapId
                     color:(UIColor*)color
{
    if (self = [super init])
    {
        m_indoorEntityId = std::string([indoorEntityId UTF8String]);
        m_indoorMapId = std::string([indoorMapId UTF8String]);
        _color = color;
        
        m_indoorHighlightId = 0;
    }
    
    return self;
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
    
    m_pIndoorEntityApi->SetHighlight(m_indoorMapId,
                                     m_indoorEntityId,
                                     [WRLDMathApiHelpers getEegeoColor:_color]);
}

#pragma mark - WRLDOverlayImpl (Private)

- (void)createNative:(Eegeo::Api::EegeoMapApi&) mapApi
{
    if ([self nativeCreated])
        return;
    
    m_pIndoorEntityApi = &mapApi.GetIndoorEntityApi();
    
    m_indoorHighlightId = m_pIndoorEntityApi->SetHighlight(m_indoorMapId,
                                                           m_indoorEntityId,
                                                           [WRLDMathApiHelpers getEegeoColor:_color]);
}

- (void)destroyNative
{
    if ([self nativeCreated] && m_pIndoorEntityApi != nullptr)
    {
        m_pIndoorEntityApi->ClearHighlight(m_indoorMapId, m_indoorEntityId);
        m_pIndoorEntityApi = nullptr;
        m_indoorHighlightId = 0;
    }
}

- (WRLDOverlayId)getOverlayId
{
    return { WRLDOverlayIndoorEntityHighlight, m_indoorHighlightId };
}

- (bool)nativeCreated
{
    return m_indoorHighlightId != 0;
}

@end
