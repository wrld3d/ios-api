#import "WRLDSearchProviderHandle.h"
#import "WRLDSearchProvider.h"

@implementation WRLDSearchProviderHandle

@synthesize identifier;

-(instancetype) initWithId: (NSInteger) uniqueId forProvider: (id<WRLDSearchProvider>) searchProvider
{
    self = [super init];
    if(self)
    {
        identifier = uniqueId;
        _provider = searchProvider;
    }
    return self;
}
@end
