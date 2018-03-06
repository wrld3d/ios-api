#include "WRLDIndoorEntityApiHelpers.h"

#import "WRLDIndoorEntityTapResult+Private.h"
#import "WRLDStringApiHelpers.h"

@interface WRLDIndoorEntityApiHelpers ()

@end

@implementation WRLDIndoorEntityApiHelpers
{
    
}

+ (WRLDIndoorEntityTapResult*) createIndoorEntityTapResult:(const Eegeo::Api::IndoorEntityPickedMessage&) withIndoorEntityPickedMessage
{
    Eegeo::v2 screenPoint = withIndoorEntityPickedMessage.ScreenPoint;
    std::string indoorMapId = withIndoorEntityPickedMessage.IndoorMapId.Value();
    WRLDIndoorEntityTapResult* indoorEntity = [[WRLDIndoorEntityTapResult alloc] initWithScreenPoint:CGPointMake(screenPoint.x, screenPoint.y)
                                                                                         indoorMapId:[NSString stringWithCString: indoorMapId.c_str() encoding:NSUTF8StringEncoding]
                                                                                     indoorEntityIds:[WRLDStringApiHelpers copyToNSStringArray:withIndoorEntityPickedMessage.EntityIds]];
    
    return indoorEntity;
}

@end
