#import "WRLDSuggestionProviderReference.h"
#import "WRLDSuggestionProvider.h"

@implementation WRLDSuggestionProviderReference
{
    id<WRLDSuggestionProvider> m_suggestionProvider;
}
-(instancetype) initWithProvider: (id<WRLDSuggestionProvider>) suggestionProvider
{
    self = [super init];
    if(self)
    {
        m_suggestionProvider = suggestionProvider;
    }
    return self;
}
-(void) addSuggestionsCompletedDelegate:(id<WRLDSearchResultsReadyDelegate>)delegate
{
    
}
@end

