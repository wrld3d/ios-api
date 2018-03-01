#include "WRLDIndoorEntityApiHelpers.h"

#import "WRLDIndoorEntityTapResult+Private.h"
#import "WRLDStringApiHelpers.h"

@interface WRLDIndoorEntityApiHelpers ()

@end

@implementation WRLDIndoorEntityApiHelpers
{
    
}

+ (WRLDIndoorEntityTapResult*) createIndoorEntityTapResult:(const Eegeo::Api::IndoorEntityPickedMessage&) withIndoorEntityPickedMessage
                                               indoorMapId:(NSString*)indoorMapId
{
    Eegeo::v2 screenPoint = withIndoorEntityPickedMessage.ScreenPoint;
    WRLDIndoorEntityTapResult* indoorEntity = [[WRLDIndoorEntityTapResult alloc] initWithScreenPoint:CGPointMake(screenPoint.x, screenPoint.y)
                                                                       indoorMapId:indoorMapId
                                                                   indoorEntityIds:[WRLDStringApiHelpers copyToNSStringArray:withIndoorEntityPickedMessage.EntityIds]];
    
    return indoorEntity;
}

@end
