#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSuggestionProvider.h"

@implementation WRLDSuggestionProviderHandle

@synthesize identifier;

-(instancetype) initWithId: (NSInteger) uniqueId forProvider: (id<WRLDSuggestionProvider>) provider
{
    self = [super init];
    if(self)
    {
        identifier = uniqueId;
        _provider = provider;
    }
    return self;
}

@end

