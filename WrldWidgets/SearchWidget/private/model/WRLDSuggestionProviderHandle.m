#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSuggestionProvider.h"

@implementation WRLDSuggestionProviderHandle

@synthesize identifier;

-(instancetype) initWithProvider: (id<WRLDSuggestionProvider>) suggestionProvider
{
    self = [super init];
    if(self)
    {
        _provider = suggestionProvider;
    }
    return self;
}

@end

