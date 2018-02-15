#include "WRLDEntityHighlightsApiHelpers.h"

@interface WRLDEntityHighlightsApiHelpers ()

@end

@implementation WRLDEntityHighlightsApiHelpers
{

}

+ (std::vector<std::string>) createNativeEntityHighlightIds:(NSArray<NSString*>*) withHightlightIds
{
    std::vector<std::string> nativeHighlightIds;
    nativeHighlightIds.reserve([withHightlightIds count]);

    for (NSString* highlightId in withHightlightIds)
    {
        const std::string nativeId = std::string([highlightId UTF8String]);
        nativeHighlightIds.emplace_back(nativeId);
    }

    return nativeHighlightIds;
}

+ (NSArray<NSString*>*) createEntityHighlightIds:(const std::vector<std::string>&) withHightlightIds
{
    NSMutableArray<NSString*>* hightlightIds = [[NSMutableArray alloc] initWithCapacity:(withHightlightIds.size())];
    for(auto& highlightId : withHightlightIds)
    {
        [hightlightIds addObject:[NSString stringWithCString: highlightId.c_str() encoding:NSUTF8StringEncoding]];
    }

    return [hightlightIds copy];
}

@end
