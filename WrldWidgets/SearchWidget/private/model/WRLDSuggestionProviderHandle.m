#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSuggestionProvider.h"

@implementation WRLDSuggestionProviderHandle
{
    id<WRLDSuggestionProvider> m_suggestionProvider;
}

@synthesize identifier;

-(instancetype) initWithProvider: (id<WRLDSuggestionProvider>) suggestionProvider
{
    self = [super init];
    if(self)
    {
        m_suggestionProvider = suggestionProvider;
    }
    return self;
}

@end

