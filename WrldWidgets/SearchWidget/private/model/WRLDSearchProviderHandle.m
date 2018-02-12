#import "WRLDSearchProviderHandle.h"
#import "WRLDSearchProvider.h"

@implementation WRLDSearchProviderHandle

@synthesize identifier;

-(instancetype) initWithProvider: (id<WRLDSearchProvider>) searchProvider
{
    self = [super init];
    if(self)
    {
        _provider = searchProvider;
    }
    return self;
}
@end
