#import "WRLDSearchProviderReference.h"
#import "WRLDSearchProvider.h"

@implementation WRLDSearchProviderReference
{
    id<WRLDSearchProvider> m_searchProvider;
}
-(instancetype) initWithProvider: (id<WRLDSearchProvider>) searchProvider
{
    self = [super init];
    if(self)
    {
        m_searchProvider = searchProvider;
    }
    return self;
}
-(void) addSearchCompletedDelegate:(id<WRLDSearchResultsReadyDelegate>)delegate
{
    
}
@end
